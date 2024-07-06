import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../model/Model.dart';
import '../model/objects/Compilazione.dart';
import '../model/objects/Domanda.dart';
import '../model/objects/Questionario.dart';
import '../model/objects/Risposta.dart';
import '../widgets/MessaggioDialogo.dart';
import 'PaginaAccesso.dart';

class RispondiQuestionario extends StatefulWidget {

  RispondiQuestionario({required Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}
class _SearchState extends State<RispondiQuestionario> {
  late Future<List<Questionario>> futureQuestionari;
  late String scadenza;
  // @override
  // void initState() {
  //   super.initState();
  //   //Model().ottieniCompilazioni(Model.utente);
  //   //futureQuestionari = Model().visualizzaQuestionariTuttti();
  //   futureQuestionari = Model().questionariDisponibili();
  // }
  void caricaQuestionari(){
    futureQuestionari = Model().questionariDisponibili();
  }

  @override
  Widget build(BuildContext context) {
    if (Model.utente.isNotEmpty) {
      caricaQuestionari();
      return Scaffold(
        appBar: AppBar(
          title: Text('Lista dei questionari disponibili per la compilazione'),
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
                        scadenza = "SCADUTO";
                      }
                      return InkWell(
                        onTap: !eCompilabile ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizDetailScreen(questionario: snapshot.data![index].domande, titoloQuestionario: snapshot.data![index].titolo, descrizioneQuestionario: snapshot.data![index].descrizione, idQuestionario: snapshot.data![index].id_questionario),
                            ),
                          );
                        } :  () { showDialog(
                          context: context,
                          builder: (context) =>
                              MessaggioDialogo(
                                titleText: "Opss...",
                                bodyText: "Impossibile compilare il questionario. Tempo scaduto!",
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
                                  Center(
                                    child: Text(
                                      "Questionario " + (index + 1).toString(),
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.lightBlue,
                                      ),
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
    } else {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Attenzione, per poter creare un questionario',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,),
              ),
              Text(
                'bisogna prima accedere.',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0), // Spazio tra i messaggi e il pulsante
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PaginaAccesso()),
                  );
                },
                child: Text('Effettua il login adesso', style: TextStyle(fontSize: 20)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.orangeAccent,
                  minimumSize: Size(300, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}


class QuizDetailScreen extends StatefulWidget {
  final List<Domanda> questionario;
  final String titoloQuestionario;
  final String descrizioneQuestionario;
  final String idQuestionario;

  QuizDetailScreen({
    required this.questionario,
    required this.titoloQuestionario,
    required this.descrizioneQuestionario,
    required this.idQuestionario,
  });

  @override
  _QuizDetailScreenState createState() => _QuizDetailScreenState();
}
class _QuizDetailScreenState extends State<QuizDetailScreen> {
  Map<int, List<bool>> selezioniRisposte = {};
  Map<int, Uint8List?> imageDataMap = {};
  Map<int, bool> _eScaricata = {}; // Variabile per tracciare se l'immagine è stata scaricata
  bool compilazioneSalvata = false;

  @override
  void initState() {
    super.initState();

    // Inizializzare la mappa con le risposte selezionate
    widget.questionario.asMap().forEach((indice, domanda) {
      selezioniRisposte[indice] = List<bool>.filled(domanda.risposte.length, false);
      _eScaricata[indice] = false;
    });
  }

  Future<void> downloadFile(String fileName, int indice) async {
    List<String> parts = fileName.split('/');
    String file_name =  parts.last;
    http.Response response = await Model().scaricaImmagine(file_name) ;

      if (response.statusCode == 200) {
        setState(() {
          imageDataMap[indice] = response.bodyBytes;
          _eScaricata[indice] = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Non è stato possibile scaricare l'immagine. Riprova più tardi.")),
        );
      }
  }

  Future<void> _salvaRisposte() async {
    // Crea una lista di risposte da salvare

    Map<String, dynamic> compilazione = {
      "id_questionario": widget.idQuestionario,
      // Usa l'ID del questionario appropriato
      "nome_utente": "",
      "data_ora": "",
      // Imposta la data e l'ora corrente
      "risposte": widget.questionario
          .asMap()
          .entries
          .map((entry) {
        int index = entry.key;
        Domanda domanda = entry.value;

        // Crea un oggetto Risposta per ogni domanda
        return Risposta(
          domanda: domanda.domanda,
          scelte: domanda.risposte
              .asMap()
              .entries
              .where((rispostaEntry) =>
          selezioniRisposte[index]![rispostaEntry.key])
              .map((rispostaEntry) => rispostaEntry.value)
              .toList(),
        );
      }).toList(),
    };

    print(compilazione);
    print(compilazione.toString());
    http.Response response = await Model().salvaCompilazione(compilazione);

    if (response.statusCode == 200) {
      setState(() {
        compilazioneSalvata = true;
      });
      // La richiesta ha avuto successo
      showDialog(
        context: context,
        builder: (context) =>
            MessaggioDialogo(
              titleText: "Perfetto",
              bodyText: "Compilazione salvata con successo",
            ),
      );
    } else {
      // La richiesta ha fallito
      showDialog(
        context: context,
        builder: (context) =>
            MessaggioDialogo(
              titleText: "Opss...",
              bodyText: "Si è verificato qualche problema, riprova",
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stai compilando il questionario \"${widget.titoloQuestionario}\""),
          backgroundColor: Colors.orange
      ),
      body: Center(
        child: Container(
          width: 1500,
          padding: const EdgeInsets.only(top: 48.0),
          child: ListView.builder(
            itemCount: widget.questionario.length,
            itemBuilder: (context, indice) {
              final domanda = widget.questionario[indice];
              return Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                margin: EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text('Domanda ${indice + 1}'),
                      ),
                      Text(
                        domanda.domanda,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Center(
                      child: Text(
                        domanda.url_immagine != "NO"
                            ? "Immagine disponibile, scaricala"
                            : "Nessuna immagine disponibile",
                        style: TextStyle(fontSize: 15),
                      ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _eScaricata[indice]! || domanda.url_immagine == "NO"
                            ? null
                            : () {
                          String fileName = domanda.url_immagine;
                          if (fileName != "NO") {
                            downloadFile(fileName, indice);
                          } else {
                            _eScaricata[indice] = true;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Nessuna immagine disponibile per questa domanda")),
                            );
                          }
                         },
                        child: Text('Download immagine',
                            style: TextStyle(fontSize: 15)
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: Size(double.infinity, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      if (imageDataMap[indice] != null && _eScaricata[indice]!) Center(child: Image.memory(imageDataMap[indice]!, height: 500)),
                      Column(
                        children: domanda.risposte.asMap().entries.map((entry) {
                          int rispostaIndex = entry.key;
                          String risposta = entry.value;
                          return CheckboxListTile(
                            title: Text(risposta),
                            value: selezioniRisposte[indice]![rispostaIndex],
                            onChanged: compilazioneSalvata // Disabilita la selezione se la compilazione è già stata salvata
                                ? null
                                : (bool? value) {
                              setState(() {
                                selezioniRisposte[indice]![rispostaIndex] = value ?? false;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: compilazioneSalvata ? null : _salvaRisposte,
        child: Icon(Icons.save),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
