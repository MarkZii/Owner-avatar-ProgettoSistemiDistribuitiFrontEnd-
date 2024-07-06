import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontendsistemidistribuitiprogetto/model/Model.dart';
import 'package:frontendsistemidistribuitiprogetto/pages/CreaQuestionario.dart';
import 'package:http/http.dart' as http;
import '../model/objects/Utente.dart';
import '../widgets/MessaggioDialogo.dart';

class NotificaUtenti extends StatefulWidget {
  String titoloGen;
  int giorni;

  NotificaUtenti(this.titoloGen, this.giorni);

  @override
  _NotificaUtentiPageState createState() => _NotificaUtentiPageState(titoloGen, giorni);
}

class _NotificaUtentiPageState extends State<NotificaUtenti> {
  List<Utente> utenti = []; // Lista degli utenti recuperati dal backend
  List<String> utentiSelezionati = []; // Lista degli ID degli utenti selezionati
  String titoloGen;
  bool isLoading = false; // Flag per indicare se stiamo caricando gli utenti
  int giorni;

  String testoOggetto = "Nuovo sondaggio disponibile!";
  String testoCorpo;// = "Ciao, il nostro "+Model.utente+" ha appena creato un nuovo questionario. Che ne dici di accedere e dirci la tua a riguardo? Ti aspettiamo presto.\nFai presto! Il questionario scade tra "+giorni.toString()+" giorni.";
  final TextEditingController textController1;// = TextEditingController(text: "Nuovo sondaggio disponibile!");
  final TextEditingController textController2;// = TextEditingController(text: "Ciao, il nostro "+Model.utente+" ha appena creato un nuovo questionario. Che ne dici di accedere e dirci la tua a riguardo? Ti aspettiamo presto.");

  _NotificaUtentiPageState(this.titoloGen, this.giorni)
      : testoCorpo = "Ciao, il nostro " + Model.utente + " ha appena creato un nuovo questionario dal titolo \'"+titoloGen+"\'. Che ne dici di accedere e dirci la tua a riguardo? Fai presto! Il questionario scade tra " + giorni.toString() + " giorni.  Ti aspettiamo!.",
        textController1 = TextEditingController(text: "Nuovo sondaggio disponibile!"),
        textController2 = TextEditingController(text: "Ciao, il nostro " + Model.utente + " ha appena creato un nuovo questionario dal titolo \'"+titoloGen+"\'. Che ne dici di accedere e dirci la tua a riguardo? Fai presto! Il questionario scade tra " + giorni.toString() + " giorni. Ti aspettiamo!.");



  @override
  void initState() {
    super.initState();
    _caricaUtenti();
  }

  // Metodo per caricare gli utenti dal backend
  Future<void> _caricaUtenti() async {
    setState(() {
      isLoading = true;
    });

    try {
      http.Response response = await Model().tuttiGliUtenti();

      if (response.statusCode == 200) {

        // Converto la stringa JSON in un List<dynamic>
        List<dynamic> jsonDataDynamic = jsonDecode(response.body);
        // Convertiamo esplicitamente in List<Map<String, dynamic>>
        List<Map<String, dynamic>> jsonData = jsonDataDynamic.cast<Map<String, dynamic>>();
        //Tolgo tutti i campi che non mi servono
        List<Map<String, dynamic>?> cleanedData = jsonData.map((item) {
          if ( item['attributes'].firstWhere((attr) => attr['name'] == 'email')['value'] == Model.utente || item['username'] == Model.utente) {
            return null; // Se l'username è uguale, restituisco null per non salvarlo
          }
          return {
            'username': item['username'],
            'email': item['attributes'].firstWhere((attr) =>
            attr['name'] == 'email')['value'],
          };
        }).where((item) => item != null).toList();

        List<Utente> loadedUsers = cleanedData.map((json) => Utente.fromJson(json!)).toList();

        setState(() {
          utenti = loadedUsers;
          isLoading = false;
        });
      } else {
        // Gestione degli errori in caso di fallimento della chiamata
        print('Errore durante il recupero degli utenti: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Errore durante il recupero degli utenti: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Metodo per inviare le email agli utenti selezionati
  Future<void> _inviaEmailUtenti() async {
    String oggetto = textController1.text.isEmpty ? testoOggetto : textController1.text;
    String corpo = textController2.text.isEmpty ? testoCorpo : textController2.text;
    http.Response response = await Model().inoltroEmail(utentiSelezionati, oggetto, corpo);

    try {
      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) =>
              MessaggioDialogo(
                titleText: "Perfetto",
                bodyText: "Email inviata con successo",
              ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) =>
              MessaggioDialogo(
                titleText: "Opss...",
                bodyText: "Si è verificato qualche problema, riprova",
              ),
        );
      }
    } catch (e) {
      print('Errore durante l\'invio delle email: $e');
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
        title: Text('Notifica utenti'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Container(
          width: 1500,
          padding: const EdgeInsets.only(top: 16.0, right: 30, left: 30, bottom: 30),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        "Seleziona gli utenti a cui si desidera inoltrare l'email di notifica del nuovo questionario.",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      if (isLoading)
                        Center(child: CircularProgressIndicator())
                      else if (utenti.isEmpty)
                        Center(child: Text('Nessun utente disponibile.'))
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: utenti.length,
                          itemBuilder: (context, index) {
                            final user = utenti[index];
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey), // Add border color
                                borderRadius: BorderRadius.circular(5), // Add border radius
                              ),
                              margin: EdgeInsets.symmetric(vertical: 5), // Add vertical margin
                              child: CheckboxListTile(
                                title: Text("Username: "+user.username, style: TextStyle(fontSize: 17)),
                                subtitle: Text("Email: "+user.email, style: TextStyle(fontSize: 16)),
                                value: utentiSelezionati.contains(user.email),
                                onChanged: (checked) {
                                  setState(() {
                                    if (checked!) {
                                      utentiSelezionati.add(user.email);
                                    } else {
                                      utentiSelezionati.remove(user.email);
                                    }
                                  });
                               },
                              ),
                            );
                          },
                        ),
                      SizedBox(height: 60),
                      TextField(
                        controller: textController1,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Inserisci l'ogetto dell'email",
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: textController2,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Inserisci il corpo dell'email",
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(height: 20), // Spacing between the list and button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(), // Empty container to push the button to the right
                          ),
                          FloatingActionButton(
                            onPressed: utentiSelezionati.isEmpty ? null : _inviaEmailUtenti,
                            tooltip: 'Invia Email',
                            child: Icon(Icons.email),
                            backgroundColor: utentiSelezionati.isEmpty
                                ? Colors.grey
                                : Colors.orange,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}