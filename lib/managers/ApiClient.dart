import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../support/Constants.dart';
import '../support/LogInResult.dart';

class ApiClient {
  late final Dio _dio; // Utilizzo di 'late' per inizializzare in seguito
  Map<String, PersistCookieJar> _userCookieJars = {};

  ApiClient() {
    _dio = Dio();
  }

  Future<Directory> _getCookieDirectory(String username) async {
    try {
      // Ottieni la directory dei documenti dell'applicazione
      Directory directory = await getApplicationDocumentsDirectory();

      // Crea una sottodirectory per i cookie dell'utente se non esiste
      Directory userCookieDir = Directory('${directory.path}/cookies/$username');
      if (!await userCookieDir.exists()) {
        await userCookieDir.create(recursive: true);
      }

      return userCookieDir;
    } catch (e) {
      print('Errore durante il recupero della directory dei cookie: $e');
      throw e; // Puoi gestire l'errore o propagarlo a monte se necessario
    }
  }
  // LOGIN E REGISTRAZIONE

  Future<LogInResult> login2(String username, String password) async {
    Uri uri = Uri.parse(Constants.ADDRESS_ECOMMERCE_SERVER+""+Constants.RICHIESTA_LOGIN_UTENTE);

    try {
      final response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, String>{
            'email': username,
            'password': password,
          }),
      );

      print(username);
      print(password);
      print(response.body.toString());

      final cookieDir = await _getCookieDirectory(username);
      PersistCookieJar cookieJar = PersistCookieJar(storage: FileStorage(cookieDir.path));
      _dio.interceptors.add(CookieManager(cookieJar));
      _userCookieJars[username] = cookieJar;

      print(_userCookieJars[username]);

      return LogInResult.logged;
    } catch (e) {
      return LogInResult.error_unknown;
    }
  }

  Future<void> login(String username, String password) async {
    try {
      // Crea e associa un nuovo PersistCookieJar a questo utente
      final cookieDir = await _getCookieDirectory(username);
      PersistCookieJar cookieJar = PersistCookieJar(storage: FileStorage(cookieDir.path));
      _dio.interceptors.add(CookieManager(cookieJar));
      _userCookieJars[username] = cookieJar;

      Response response = await _dio.post(
        'https://example.com/login',
        data: {'username': username, 'password': password},
      );
      print('Login successful: ${response.data}');
    } catch (e) {
      print('Login failed: $e');
    }

  }


  Future<void> fetchData(String username) async {
    try {
      // Utilizza il CookieJar associato all'utente
      if (_userCookieJars.containsKey(username)) {
        _dio.interceptors.add(CookieManager(_userCookieJars[username]!));
      }

      Response response = await _dio.get('https://example.com/data');
      print('Data: ${response.data}');
    } catch (e) {
      print('Failed to fetch data: $e');
    }
  }

  Future<void> logout(String username) async {
    try {
      // Optional: Inform the server about the logout if necessary
      await _dio.post('https://example.com/logout');

      // Rimuovi il CookieJar associato all'utente
      if (_userCookieJars.containsKey(username)) {
        await _userCookieJars[username]?.deleteAll();
        _userCookieJars.remove(username);
      }
      print('Logout successful');
    } catch (e) {
      print('Logout failed: $e');
    }
  }
}