import 'dart:io';
import 'dart:convert';
import 'package:frontendsistemidistribuitiprogetto/support/Constants.dart';
import 'package:frontendsistemidistribuitiprogetto/support/ErrorListener.dart';
import 'package:http/http.dart' as http;

import '../model/objects/Questionario.dart';



enum TypeHeader {
  json,
  urlencoded
}


class RestManager {
  late ErrorListener ? delegate;
  String ? token;

  Future<String> _makeRequest(String serverAddress, String servicePath, String method, TypeHeader type, {Map<String, String> ? value, dynamic body}) async {
    print("ciao3");
    print(serverAddress);
    print(servicePath);
    print(value);
    Uri uri = Uri.parse(serverAddress+""+servicePath);
    print(uri);
    bool errorOccurred = false;
    while (true) {
      try {
        var response;
        // setting content type
        String contentType = "";
        dynamic formattedBody;
        if (type == TypeHeader.json) {
          contentType = "application/json;charset=utf-8";
          formattedBody = json.encode(body);
        }
        else if (type == TypeHeader.urlencoded) {
          contentType = "application/x-www-form-urlencoded";
          formattedBody = body.keys.map((key) => "$key=${body[key]}").join("&");
        }
        // setting headers
        Map<String, String> headers = Map();
        headers[HttpHeaders.contentTypeHeader] = contentType;
        print(token);
        if (token != null) {
          print("OKOKOK");
          headers[HttpHeaders.authorizationHeader] = 'bearer $token';
        }

        //
        switch (method) {
          case "post":
            response = await http.post(
              uri,
              headers: headers,
              body: formattedBody,
            );
            break;
          case "get":
            response = await http.get(
              uri,
              headers: headers,
            );
            break;
          case "put":
            response = await http.put(
              uri,
              headers: headers,
            );
            break;
          case "delete":
            response = await http.delete(
              uri,
              headers: headers,
            );
            break;
        }

        return response.body;
      } catch (err) {
        if (delegate != null && !errorOccurred) {
          delegate?.errorNetworkOccurred(Constants.MESSAGE_CONNECTION_ERROR);
          errorOccurred = true;
        }
        await Future.delayed(
            const Duration(seconds: 5), () => null); // not the best solution
      }
    }
  }

  Future<String> makePostRequest(String serverAddress, String servicePath, dynamic value, {TypeHeader type = TypeHeader.json}) async {
    Future<String> res=_makeRequest(serverAddress, servicePath, "post", type, value: {}, body: value);
    return res;
  }

  Future<String> makeGetRequest(String serverAddress, String servicePath, [Map<String, String>?value, TypeHeader? type]) async {
    print("ciao2");
    Future<String> res= _makeRequest(serverAddress, servicePath, "get", TypeHeader.json, value: value!);
    return res;
  }

  Future<String> makePutRequest(String serverAddress, String servicePath, [Map<String, String> ?value, TypeHeader ?type]) async {
    return _makeRequest(serverAddress, servicePath, "put", type!, value: value!);
  }

  Future<String> makeDeleteRequest(String serverAddress, String servicePath, [Map<String, String> ?value, TypeHeader ?type]) async {
    return _makeRequest(serverAddress, servicePath, "delete", type!, value: value!);
  }

  // Future<List<Questionario>> fetchQuestionari() async {
  //   final response = await http.get(Uri.parse('"http://localhost:8080/questionari/tutti'));
  //
  //   if (response.statusCode == 200) {
  //     List jsonResponse = json.decode(response.body);
  //     return jsonResponse.map((data) => Questionario.fromJson(data)).toList();
  //   } else {
  //     throw Exception('Failed to load questionari');
  //   }
  // }

}