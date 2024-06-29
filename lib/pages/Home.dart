import 'dart:async';

import 'package:frontendsistemidistribuitiprogetto/pages/PaginaAccesso.dart';
import 'package:frontendsistemidistribuitiprogetto/pages/PaginaRegistrazione.dart';
import 'package:frontendsistemidistribuitiprogetto/pages/RispondiQuestionario.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/Model.dart';
import '../widgets/MessaggioDialogo.dart';
import 'CreaQuestionario.dart';
import 'RispondiQuestionario2.dart';
import 'VisualizzaRisultati.dart';
import 'VisualizzaTuttiQuestionari.dart';
import 'package:flutter/material.dart';
import 'package:frontendsistemidistribuitiprogetto/support/Constants.dart';

import 'ChiSiamo.dart';


class Home extends StatefulWidget {
  final String title;

  Home({required Key key, required this.title}) : super(key: key);

  _LayoutState createState() => _LayoutState(title);
}

class _LayoutState extends State<Home> {
  String title="";
  bool _showMessage = false;
  String _message = '';


  _LayoutState(String title) {
    this.title = Constants.APP_NAME;
  }

  /**
   * Nota che uno scaffold contiene un appBar e un
   * body. l'appbar viene visualizzato nella parte
   * superiore della pagina, mentre il "body" nella
   * sua parte inferiore e contiene il contenuto
   * principale dell'applicazione.
   */
// Funzione per lanciare URL
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }  @override
  Widget build(BuildContext context) {
    var i =0;
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title!,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end, // Allineamento orizzontale a sinistra
                  children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                              MaterialPageRoute(builder: (context) => PaginaAccesso()),
                            );
                          },
                        child: Text('Accedi',
                            style: TextStyle(color: Colors.black,
                              fontSize: 20.0,
                            )
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if(Model().logout()){
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  MessaggioDialogo(
                                    titleText: "Perfetto",
                                    bodyText: "Hai effettuato il logout",
                                  ),
                            );
                          }else{
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  MessaggioDialogo(
                                    titleText: "Opss...",
                                    bodyText: "Perfavore accedere prima",
                                  ),
                            );
                          };
                        },
                        child: Text('Logout',
                            style: TextStyle(color: Colors.black,
                              fontSize: 20.0,
                            )
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PaginaRegistrazione()),
                          );
                        },
                        //   onPressed: () => _launchURL('https://sitoquestionario.auth.eu-north-1.amazoncognito.com/login?response_type=code&client_id=5tm94abk7017u4tfesuugnclp3&redirect_uri=http://localhost:8080/login/oauth2/code/cognito'),
                        child: Text('Registrati',
                            style: TextStyle(color: Colors.black,
                              fontSize: 20.0,
                            )
                        ),
                      ),
                      // TextButton(
                      //   onPressed: () => _launchURL('https://sitoquestionario.auth.eu-north-1.amazoncognito.com/logout?response_type=code&client_id=5tm94abk7017u4tfesuugnclp3&redirect_uri=http://localhost:8080/'),
                      //   child: Text('Log Out',
                      //       style: TextStyle(color: Colors.black,
                      //         fontSize: 15.0,
                      //         fontWeight: FontWeight.bold,
                      //       )
                      //    ),
                      // ),
                    ],                    // IconButton(
                ),
              ),
            ],
          ),
          bottom: TabBar(
            indicatorColor: Colors.orangeAccent,
            /*
             * La tabBar rappresenta la barra delle schede, e mostra le etichette
             * alle pagine. E viene visualizzato nel bottom dell'appbar.
             */
            labelColor: Colors.black,

            tabs: [
              Tab(
                child: Text( 'Chi siamo',
                        style: TextStyle(fontSize: 20), // Imposta la dimensione del carattere a 20
                        ),
                ),
              Tab(
                child: Text( 'Lista questionari',
                        style: TextStyle(fontSize: 20), // Imposta la dimensione del carattere a 20
                        ),
                ),
              Tab(
                child: Text( 'Crea Questionario',
                  style: TextStyle(fontSize: 20), // Imposta la dimensione del carattere a 20
                ),
              ),
              Tab(
                child: Text( 'Compila un questionario',
                  style: TextStyle(fontSize: 20), // Imposta la dimensione del carattere a 20
                ),
              ),
              Tab(
                child: Text("Statistiche",
                  style: TextStyle(fontSize: 20)
                ),
              ),
            ],
          ),
        ),
          body: TabBarView(
          /*
           * Dentro TabBarView viene rappresentato il contenuto di ciascuna scheda
           * Questa cosa è fatta in ordine di scrittura.
           * QUINDI NOTA COME ALL'INIZIO VIENE FATTO VEDERE SOLAMENTE LE ICONE PRESENTI
           * DENTRO TabBar, POI UNA VOLTA CHE SI CLICCA IN UNA SPECIFICA ICONA SI MOSTRA
           * TALE PAGINA E SI NASCODONO LE ALTRE.
           */
          children: [
            ChiSiamo(key: UniqueKey()),
            VisualizzaTuttiQuestionari(key: UniqueKey()),
            CreaQuestionario(key: UniqueKey()),
            RispondiQuestionario(key: UniqueKey()),
            VisualizzaRisultati(key: UniqueKey()),
          ],
        ),
      ),
    );
  }
}