import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widgets/MessaggioDialogo.dart';
import 'package:frontendsistemidistribuitiprogetto/model/Model.dart';

class PaginaRegistrazione extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<PaginaRegistrazione> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _usernameEmpty = false;
  bool _emailEmpty = false;
  bool _passwordEmpty = false;
  bool _confirmPasswordEmpty = false;
  String _errorMessage = '';

  void _registrazione() async {
    setState(() {
      _usernameEmpty = _usernameController.text.isEmpty;
      _emailEmpty = _emailController.text.isEmpty;
      _passwordEmpty = _passwordController.text.isEmpty;
      _confirmPasswordEmpty = _confirmPasswordController.text.isEmpty;
    });

    if(!_usernameEmpty && !_emailEmpty && !_passwordEmpty && !_confirmPasswordEmpty){
      // print(_usernameController.text);
      // print(_emailController.text);
      // print(_passwordController.text);
      // print(_confirmPasswordController.text);
      _errorMessage = '';
      if (!_validateEmail(_emailController.text)) {
        _errorMessage = 'Attenzione, inserire una email valida';
        return;
      }
      if (!_validatePassword(_passwordController.text) || !_validatePassword(_confirmPasswordController.text)) {
        _errorMessage = 'Attenzione, le password non rispettano il seguente formato: \n\tInserire almeno 8 caratteri;\n\tInserire almeno una lettera minuscola;\n\tInserire almeno una lettera maiuscola\n\tInserire almeno un numero;\n\tInserire almeno un carattere speciale.';
        return;
      }
      if (_passwordController.text != _confirmPasswordController.text) {
        _errorMessage = 'Attenzione, le password non corrispondono';
      }else {
         http.Response response = await Model().registrazioneUtente(_usernameController.text, _emailController.text, _passwordController.text);

        if (response.statusCode == 200) {
          // La richiesta ha avuto successo
          print('Success: ${response.body}');
          showDialog(
            context: context,
            builder: (context) => MessaggioDialogo(
              titleText: "Perfetto",
              bodyText: response.body.toString(),
            ),
          );
        } else {
          // La richiesta ha fallito
          print('Failed: ${response.statusCode}');
          showDialog(
            context: context,
            builder: (context) => MessaggioDialogo(
              titleText: "Opss...",
              bodyText: response.body.toString(),
            ),
          );
        }
      }
    }
  }

  bool _validateEmail(String email) {
    String emailPattern = r'^[^@]+@[^@]+\.[^@]+';
    RegExp regex = RegExp(emailPattern);
    return regex.hasMatch(email);
  }

  bool _validatePassword(String password) {
    String passwordPattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{9,}$';
    RegExp regex = RegExp(passwordPattern);
    return regex.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Registrazione nuovo utente'),
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
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      errorText: _usernameEmpty
                          ? 'Questo campo non può essere vuoto'
                          : null,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _usernameEmpty ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
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
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Conferma Password',
                      errorText: _confirmPasswordEmpty
                          ? 'Questo campo non può essere vuoto'
                          : null,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _confirmPasswordEmpty ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                    obscureText: true,
                  ),

                  SizedBox(height: 20),

                  if (_errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: Text(
                        _errorMessage,
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 18
                        ),
                      ),
                    ),
                  ElevatedButton(
                    onPressed: _registrazione,
                    child: Text('Registrazione', style: TextStyle(fontSize: 20)),
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