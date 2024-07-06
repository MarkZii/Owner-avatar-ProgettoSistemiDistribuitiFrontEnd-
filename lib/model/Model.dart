import 'dart:async';
import 'dart:convert';
import 'package:frontendsistemidistribuitiprogetto/model/objects/Questionario.dart';
import 'package:frontendsistemidistribuitiprogetto/model/objects/Risultati.dart';

import '../support/Constants.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:typed_data';

import '../support/LogInResult.dart';
import 'objects/Autenticazione.dart';


class Model {
  static Model sharedInstance = Model();
  static String _userAccessToken = "";
  static String utente = "";

  Autenticazione? _authenticationData;

  //GESTIONE QUESTIONARI
  Future<http.Response> caricaQuestionario(Map<String, dynamic> questionarioCompleto) async {
    Uri uri = Uri.parse(Constants.ADDRESS_ECOMMERCE_SERVER+""+Constants.RICHIESTA_SALVA_QUESTIONARI);

    questionarioCompleto.update("nome_autore", (value) => utente);
    try {
      var response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + _userAccessToken!,
        },
        body: jsonEncode(questionarioCompleto),
      );

      return response;
    } catch (e) {
      throw Exception('Caricamento fallito');
    }
  }
  Future<List<Questionario>> visualizzaQuestionariTutti() async {
    Uri uri = Uri.parse(Constants.ADDRESS_ECOMMERCE_SERVER+""+Constants.RICHIESTA_TUTTI_QUESTIONARI);
    try {
      var response = await http.get(
        uri,
        // headers: <String, String>{
        //   'Authorization': 'Bearer ' + _userAccessToken!,
        // },
      );
      String lista = response.body;
      List<Questionario> lista2 = List<Questionario>.from(json.decode(lista).map((i) => Questionario.fromJson(i)).toList());
      print(lista2);
      return lista2;
    } catch (e) {
      throw Exception('Caricamento fallito'+e.toString());
    }
  }

  //GESTIONE COMPILAZIONE
  Future<List<Questionario>> questionariDisponibili() async {
    Uri uri = Uri.parse(Constants.ADDRESS_ECOMMERCE_SERVER+""+Constants.RICHIESTA_COMPILAZIONI_DISPONIBILI+"?nome_utente="+utente);
    try {
      var response = await http.get(
        uri,
        headers: <String, String>{
          'Authorization': 'Bearer ' + _userAccessToken!,
        },
      );
      String lista = response.body;
      List<Questionario> lista2 = List<Questionario>.from(json.decode(lista).map((i) => Questionario.fromJson(i)).toList());
      return lista2;
    } catch (e) {
      throw Exception('Caricamento fallito'+e.toString());
    }
  }
  Future<http.Response> salvaCompilazione(Map<String, dynamic> compilazioneCompleta) async {
    Uri uri = Uri.parse(Constants.ADDRESS_ECOMMERCE_SERVER+""+Constants.RICHIESTA_SALVA_COMPILAZIONE);
    print(compilazioneCompleta.toString());
    compilazioneCompleta.update("nome_utente", (value) => utente);

    try {
      var response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + _userAccessToken!,
        },
        body: jsonEncode(compilazioneCompleta),
      );

      return response;
    } catch (e) {
      throw Exception('Caricamento fallito');
    }
  }
  Future<http.Response> ottieniCompilazioni(String nome_utente) async {
    Uri uri = Uri.parse(Constants.ADDRESS_ECOMMERCE_SERVER+""+Constants.RICHIESTA_RICERCA_COMPILAZIONE+"?nome_utente="+nome_utente);


    try {
      var response = await http.get(
        uri,
        headers: <String, String>{
          'Authorization': 'Bearer ' + _userAccessToken!,
        },
      );
      print(response.body);
      return response;
    } catch (e) {
      throw Exception('Caricamento fallito');
    }
  }

  //GESTIONE INOLTRO EMAIL
  Future<http.Response> inoltroEmail(List<String> emailUtenti, String oggetto, String corpo) async {
    Uri uri = Uri.parse(Constants.ADDRESS_ECOMMERCE_SERVER +""+Constants.RICHIESTA_INVIO_EMAIL_TUTTI);
    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Authorization': 'Bearer ' + _userAccessToken!,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: <String, String>{
          'toEmail': emailUtenti.join(','),
          'oggetto': oggetto,
          'corpo': corpo,
        },
      );
      print(response.body);
      return response;
    } catch (e) {
      throw Exception('Registrazione fallita');
    }
  }

  //GESTIONE IMMAGINI
  Future<http.Response> caricaImmagine(Uint8List? _imageBytes, int indice) async {
    Uri uri = Uri.parse(Constants.ADDRESS_ECOMMERCE_SERVER+""+Constants.RICHIESTA_CARICA_IMMAGINI);
    var request = http.MultipartRequest('POST', uri, );
    request.headers['Authorization'] = 'Bearer ' + _userAccessToken!;

    // Aggiungi l'immagine come MultipartFile
    var multipartFile = http.MultipartFile.fromBytes(
      'file',
      _imageBytes!,
      filename: 'Domanda ${indice}.jpg', // Sostituisci con il nome appropriato del file
      contentType: MediaType('image', 'jpeg'), // Sostituisci con il tipo di contenuto appropriato
    );
    request.files.add(multipartFile);

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        // Gestisci qui la risposta dal server se necessario
        return response;
      } else {
        print('Errore durante il caricamento del file: ${response.reasonPhrase}');
        return response;
      }
    } catch (e) {
      print('Eccezione durante il caricamento del file: $e');
      throw Exception('Caricamento fallito');
    }
  }
  Future<http.Response> eliminaImmagine(String fileName) async {
    Uri uri = Uri.parse(Constants.ADDRESS_ECOMMERCE_SERVER+""+Constants.RICHIESTA_ELIMINA_IMMAGINI+"?file_name="+fileName);

    final response = await http.get(uri,
      headers: <String, String>{
        'Authorization': 'bearer '+_userAccessToken!,
      },
    );

    try {
      if (response.statusCode == 200) {
        // Gestisci qui la risposta dal server se necessario
        print(response.body);
        return response;
      } else {
        print('Errore durante il caricamento del file: ${response.reasonPhrase}');
        return response;
      }
    } catch (e) {
      print('Eccezione durante il caricamento del file: $e');
      throw Exception('Caricamento fallito');
    }
  }
  Future<http.Response> scaricaImmagine(String urlImmagine) async {
    Uri uri = Uri.parse(Constants.ADDRESS_ECOMMERCE_SERVER+""+Constants.RICHIESTA_DOWNLOADNOME_IMMAGINI+"?file_name="+urlImmagine);
    print(uri);
    final response = await http.get(uri,
      headers: <String, String>{
        'Authorization': 'bearer '+_userAccessToken!,
      },
    );

    try {
      if (response.statusCode == 200) {
        // Gestisci qui la risposta dal server se necessarioì
        return response;
      } else {
        print('Errore durante il caricamento del file'); //: ${response.bodyBytes}');
        return response;
      }
    } catch (e) {
      print('Eccezione durante il caricamento del file: $e');
      throw Exception('Caricamento fallito');
    }
  }
  Future<Uint8List> scaricaImmagine2(String link) async {
    // Esegui la richiesta GET all'endpoint per ottenere l'URL dell'immagine
    Uri uri = Uri.parse(Constants.ADDRESS_ECOMMERCE_SERVER+""+Constants.RICHIESTA_DOWNLOADNOME_IMMAGINI+"?file_name="+link);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      // Presumi che il server ritorni l'URL dell'immagine come una stringa
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image');
    }
  }

  // LOGIN E REGISTRAZIONE
  Future<LogInResult> accessoUtente(String username, String password) async {
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

      _authenticationData = Autenticazione.fromJson(jsonDecode(response.body));
      _userAccessToken = _authenticationData!.getAccessToken();
      utente = username;
      print(_userAccessToken.toString());
      print(utente);
      return LogInResult.logged;
    } catch (e) {
      return LogInResult.error_unknown;
    }
  }
  Future<http.Response> registrazioneUtente(String username, String email, String password) async {
    Uri uri = Uri.parse(Constants.ADDRESS_ECOMMERCE_SERVER+""+Constants.RICHIESTA_REGISTRAZIONE_UTENTE);

    try {
      final response = await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },

        body: <String, String>{
          'username': username,
          'email': email,
          'password': password,
        },
      );
      return response;
    } catch (e) {
      throw Exception('Registrazione fallita');
    }
  }
  Future<http.Response> tuttiGliUtenti() async {
    Uri uri = Uri.parse(Constants.ADDRESS_ECOMMERCE_SERVER+""+Constants.RICHIESTA_TUTTI_UTENTI);

    try {
      final response = await http.get(uri,
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'bearer '+_userAccessToken!,
        },

      );
      print(response.body);
      return response;
    } catch (e) {
      throw Exception('Registrazione fallita');
    }
  }
  bool logout() {
    if(utente.isNotEmpty){
      utente = "";
      _userAccessToken = "";
      return true;
    }
    return false;
  }

  //GESTION RISULTATI
  Future<List<Risultati>> visualizzaRisultatiTuttti() async {
    Uri uri = Uri.parse(Constants.ADDRESS_ECOMMERCE_SERVER+""+Constants.RICHIESTA_RISULTATI_UTENTI);
    try {
      var response = await http.get(
        uri,
        // headers: <String, String>{
        //   'Authorization': 'Bearer ' + _userAccessToken!,
        // },
      );
      String lista = response.body;
      List<Risultati> lista2 = List<Risultati>.from(json.decode(lista).map((i) => Risultati.fromJson(i)).toList());
      return lista2;
    } catch (e) {
      throw Exception('Caricamento fallito'+e.toString());
    }
  }

}