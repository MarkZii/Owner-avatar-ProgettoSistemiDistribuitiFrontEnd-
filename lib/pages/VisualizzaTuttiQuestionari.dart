import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontendsistemidistribuitiprogetto/model/objects/Domanda.dart';
import 'package:frontendsistemidistribuitiprogetto/model/Model.dart';
import '../model/objects/Questionario.dart';
import 'dart:typed_data';


class VisualizzaTuttiQuestionari extends StatefulWidget {

  VisualizzaTuttiQuestionari({required Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<VisualizzaTuttiQuestionari> {
  late Future<List<Questionario>> futureQuestionari;
  late String scadenza;

  @override
  void initState() {
    super.initState();
    futureQuestionari = Model().visualizzaQuestionariTutti();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista di tutti i questionari'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.black, // Colore del testo del titolo
          fontSize: 20.0,
        ),
      ),
      body: Center(
          child: Container(
          width: 1500,
            padding: const EdgeInsets.only(top: 16.0, right: 30, left: 30),
            child: FutureBuilder<List<Questionario>>(
              future: futureQuestionari,
              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Errore: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Nessun questionario disponibile', style: TextStyle(fontSize: 20)));
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.all(32.0),

                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      DateTime dataCreazione = DateTime.parse(snapshot.data![index].data_ora);
                      int differenzaGiorni = DateTime.now().difference(dataCreazione).inDays;
                      bool eCompilabile = differenzaGiorni > snapshot.data![index].durata;

                      if(!eCompilabile){
                        scadenza = "La scadenza del questionario è dopo: " + snapshot.data![index].durata.toString()+" giorni dalla data di creazione";
                      }else{
                        scadenza = "Campagna di sottomissione scaduta";
                      }
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DettaglioQuestionarioPage(questionario: snapshot.data![index].domande, nomeQuestionario: snapshot.data![index].titolo),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Card(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Questionario " + (index + 1).toString(),
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.lightBlue
                                    ),
                                   ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    snapshot.data![index].titolo,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    snapshot.data![index].descrizione,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    "Creato da: " + snapshot.data![index].nome_autore+" di "+snapshot.data![index].data_ora,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    scadenza,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
        ),
      ),
    );
  }

}

class DettaglioQuestionarioPage extends StatelessWidget {
  final List<Domanda> questionario;
  String nomeQuestionario = "";

  DettaglioQuestionarioPage({required this.questionario, required this.nomeQuestionario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dettaglio Questionario \""+nomeQuestionario+"\""),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Center(
          child: Container(
            width: 1500,
            padding: const EdgeInsets.only(top: 48.0),
            child: ListView.builder(
                  itemCount: questionario.length,
                  itemBuilder: (BuildContext context, int index) {
                    Future<Uint8List>? imageFuture;
                    if (questionario[index].url_immagine != "NO") {
                      List<String> parts = questionario[index].url_immagine.split('/');
                      String file_name =  parts.last;
                      imageFuture = Model().scaricaImmagine2(file_name);
                    }
                    return Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      margin: EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
                      child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Domanda "+(index+1).toString(),
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.lightBlue
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                questionario[index].domanda,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 24.0),
                              FutureBuilder<Uint8List>(
                                future: imageFuture,
                                builder: (context, immagine) {
                                  if (immagine.connectionState == ConnectionState.waiting) {
                                    return Center(child: CircularProgressIndicator());
                                  } else if (immagine.hasError) {
                                    return Center(child: Text('Errore durante il caricamento dell\'immagine'));//${immagine.error}'));
                                  } else if (!immagine.hasData) {
                                    return Center(child: Text('Nessuna immagine disponibile'));
                                  } else {
                                    return Container(
                                      width: 1400,
                                      height: 500.0, // Altezza standard per tutte le immagini
                                      child: Image.memory(
                                        immagine.data!,
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  }
                                },
                              ),
                              SizedBox(height: 24.0),
                              Text(
                                'Risposte possibili:',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: questionario[index].risposte.map((risposta) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.arrow_forward_ios_sharp,
                                      color: Colors.orangeAccent,
                                      size: 24.0,
                                    ),
                                    title: Text(
                                      risposta,
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                  ),
                                )).toList(),
                              )
                            ],
                          ),
                        ),
                    );
                  },
                ),
            ),
        ),
      );
    }
}
