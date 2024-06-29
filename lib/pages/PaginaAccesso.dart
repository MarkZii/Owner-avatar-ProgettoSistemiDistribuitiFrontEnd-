
import 'package:flutter/material.dart';
import 'package:frontendsistemidistribuitiprogetto/managers/ApiClient.dart';
import 'package:frontendsistemidistribuitiprogetto/pages/Home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/Model.dart';
import '../support/Constants.dart';
import '../support/LogInResult.dart';
import '../widgets/MessaggioDialogo.dart';

class PaginaAccesso extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<PaginaAccesso> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _emailEmpty = false;
  bool _passwordEmpty = false;

  Future<void> _login() async {
    setState(() {
      _emailEmpty = _emailController.text.isEmpty;
      _passwordEmpty = _passwordController.text.isEmpty;
    });

    final String email = _emailController.text;
    final String password = _passwordController.text;
    // print(email);
    // print(password);

    LogInResult response = await Model().accessoUtente(_emailController.text, _passwordController.text);
    print(response.toString());
    if (response == LogInResult.logged) {
      // La richiesta ha avuto successo
      //print('Success: ${response.body}');
      showDialog(
        context: context,
        builder: (context) => MessaggioDialogo(
          titleText: "Perfetto",
          bodyText: "Utente loggato con successo",
        ),
      );

    } else if (response == LogInResult.error_unknown){
      // La richiesta ha fallito
      //print('Failed: ${response.statusCode}');
      showDialog(
        context: context,
        builder: (context) => MessaggioDialogo(
          titleText: "Opss...",
          bodyText: "Credenziali errate, riprovare",
        ),
      );
    }
    // } catch (e) {
    //   print('Error: $e');
    // }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Login'),
          backgroundColor: Colors.orangeAccent,
      ),
      body: Center(
          child: Container(
          width: 1500,
          padding: const EdgeInsets.only(top: 48.0, right: 30, left: 30),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Username or Email',
                      errorText: _emailEmpty
                          ? 'Questo campo non può essere vuoto'
                          : null,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _emailEmpty ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      errorText: _passwordEmpty
                          ? 'Questo campo non può essere vuoto'
                          : null,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _passwordEmpty ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _login,
                    child: Text('Accedi', style: TextStyle(fontSize: 20)),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.orangeAccent,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            5), // Angoli arrotondati
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ),
      ),
    );
  }
}
