
import 'package:frontendsistemidistribuitiprogetto/pages/Home.dart';
import 'package:frontendsistemidistribuitiprogetto/support/Constants.dart';
import 'package:flutter/material.dart';


class Radice extends StatelessWidget {
  const Radice({required super.key});



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.APP_NAME,
      theme: ThemeData(//tema classico, tema chiaro
        primaryColor: Colors.black
      ),
      home: Home(key: UniqueKey(), title: Constants.APP_NAME),//widget di avvio dell'applicazione.
    );
  }
}
