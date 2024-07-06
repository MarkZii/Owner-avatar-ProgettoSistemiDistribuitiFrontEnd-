import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontendsistemidistribuitiprogetto/pages/PaginaAccesso.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:uuid/uuid.dart';
import '../model/Model.dart';
import '../model/objects/Domanda.dart';
import '../support/Constants.dart';
import '../widgets/MessaggioDialogo.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import 'NotificaUtenti.dart';

class CreaQuestionario extends StatefulWidget {
  @override
  CreaQuestionario({required Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<CreaQuestionario> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  static late String titoloGen = "";
  static late int durataGiorni = 0;
  List<Domanda> domande = [];
  //List<String> immaginiDove = [];
  Map<int, List<TextEditingController>> _controllersMap = {};

  bool _titleEmpty = false;
  bool _durationEmpty = false;
  bool _descriptionEmpty = false;
  bool questionarioSalvato = false;
  bool _isNotANumber = false;

  void _caricaImmagine(html.File file, Domanda domanda) async {
    // Leggi il contenuto dell'immagine come base64
    final reader = html.FileReader();
    reader.readAsDataUrl(file);
    await reader.onLoad.first;
    String base64Data = reader.result.toString().split(',').last;

    // Aggiorna il campo URL dell'immagine nella domanda
    setState(() {
      domanda.url_immagine = base64Data; // In questo esempio, memorizziamo l'immagine come base64
    });
  }

  Future<void> _salvaQuestionario() async {
    final String titolo = _titleController.text;
    final String descrizione = _descriptionController.text;
    final int durata = int.parse(_durationController.text);
    var uuid = Uuid();

    if (!_descriptionEmpty) {
      try {
        int.parse(_descriptionController.text);
      } catch (e) {
        _isNotANumber = true;
      }
    }

    titoloGen = titolo;
    durataGiorni = durata;
    setState(() {
      _titleEmpty = _titleController.text.isEmpty;
      _descriptionEmpty = _descriptionController.text.isEmpty;
      _durationEmpty = _durationController.text.isEmpty;
      _isNotANumber;
    });

    if(domande.isEmpty){
      showDialog(
        context: context,
        builder: (context) =>
            MessaggioDialogo(
              titleText: "ATTENZIONE",
              bodyText: "Bisogna inserire almeno una domanda",
            ),
      );
      return;
    }
    if(!_titleEmpty && !_descriptionEmpty && !_durationEmpty ) {
      List<Map<String, dynamic>> domandeJson = domande.map((domande) =>
          domande.toJson()).toList();


      Map<String, dynamic> questionarioCompleto = {
        'id_questionario': uuid.v4(),
        'nome_autore': '',
        'data_ora': '',
        'titolo': titolo,
        'descrizione': descrizione,
        'durata': durata,
        'domande': domandeJson,
      };
      print(domande.toString());
      print(domandeJson.toString());
      print(questionarioCompleto.toString());

      http.Response response = await Model().caricaQuestionario(questionarioCompleto);

      if (response.statusCode == 200) {
        // La richiesta ha avuto successo
        showDialog(
          context: context,
          builder: (context) =>
              MessaggioDialogo(
                titleText: "Perfetto",
                bodyText: "Questionario salvato con successo",
              ),
        );
        setState(() {
          questionarioSalvato = true;
        });
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
  }

  void _apriNuovaPagina() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotificaUtenti(titoloGen,durataGiorni)),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _controllersMap.values.forEach((controllers) {
      controllers.forEach((controller) => controller.dispose());
    });
    super.dispose();
  }

  void _aggiungiDomanda() {
    setState(() {
      domande.add(Domanda(domanda: '', risposte: [], url_immagine: ""));
      _controllersMap[domande.length - 1] = [];
    });
  }

  void _rimuoviDomanda(int index) {
    setState(() {
      String linkImmagine = domande.elementAt(index).url_immagine;
      List<String> parti = linkImmagine.split('/');
      String fileName = parti.last;
      domande.removeAt(index);
      _controllersMap.remove(index);
      final newMap = <int, List<TextEditingController>>{};
      int newIndex = 0;
      _controllersMap.forEach((key, value) {
        if (key != index) {
          newMap[newIndex++] = value;
        }
      });
      _controllersMap = newMap;
      if(fileName.isNotEmpty)
        Model().eliminaImmagine(fileName);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Model.utente.isNotEmpty) {
      return Scaffold(
        body: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 1500),
            padding: const EdgeInsets.only(top: 48.0, right: 30, left: 30, bottom: 30),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Titolo del Questionario',
                      errorText: _titleEmpty
                          ? 'Questo campo non può essere vuoto'
                          : null,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _titleEmpty ? Colors.red : Colors.grey,
                        ),

                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Descrizione del Questionario',
                      errorText: _descriptionEmpty
                          ? 'Questo campo non può essere vuoto'
                          : null,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _descriptionEmpty ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _durationController,
                    decoration: InputDecoration(
                      labelText: 'Durata in giorni del questionario',
                      errorText: _durationEmpty
                          ? 'Questo campo non può essere vuoto'
                          : null,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _durationEmpty ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20),
                  ListTile(
                    title: Text('Lista domande:'),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: domande.length + 1,
                    itemBuilder: (context, index) {
                      if (index == domande.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                            onPressed: _aggiungiDomanda,
                            child: Text('Aggiungi Domanda',
                                style: TextStyle(fontSize: 20)),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              backgroundColor: Colors.orangeAccent,
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        );
                      }
                      return QuestionWidget(
                        key: ValueKey(domande[index]),
                        domanda: domande[index],
                        onDelete: () => _rimuoviDomanda(index),
                        indice: index,
                        controllers: _controllersMap[index] ?? [],
                        //immagini: immaginiDove,
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: questionarioSalvato ? _apriNuovaPagina : _salvaQuestionario,
                    child: Text(
                      questionarioSalvato ? 'Notifica ora il questionario' : 'Salva Questionario',
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.orangeAccent,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),

                ],
              ),
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

class QuestionWidget extends StatefulWidget {
  //final List<String> immagini;
  final Domanda domanda;
  final VoidCallback onDelete;
  final int indice;
  final List<TextEditingController> controllers;

  QuestionWidget({
    required Key key,
    //required this.immagini,
    required this.domanda,
    required this.onDelete,
    required this.indice,
    required this.controllers
  }) : super(key: key);

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  TextEditingController _domandaController = TextEditingController();
  bool _giaCaricata = false;
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _domandaController = TextEditingController(text: widget.domanda.domanda);
    if (widget.controllers.isEmpty) {
      widget.controllers.addAll(widget.domanda.risposte.map((risposta) => TextEditingController(text: risposta)));
    }
  }

  @override
  void dispose() {
    _domandaController.dispose();
    super.dispose();
  }

  void _resetAnswers() {
    setState(() {
      widget.controllers.clear();
      widget.domanda.risposte.clear();
    });
  }

  void _generateAnswers(int count) {
    setState(() {
      widget.controllers.clear();
      widget.domanda.risposte.clear();
      for (int i = 0; i < count; i++) {
        widget.controllers.add(TextEditingController());
        widget.domanda.risposte.add('');
      }
    });
  }

  void _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.isNotEmpty) {
      PlatformFile file = result.files.first;
      html.File fileHtml = html.File([file.bytes!.buffer], file.name);

      final reader = html.FileReader();
      reader.readAsDataUrl(fileHtml);
      reader.onLoad.first.then((event) {
        setState(() {
          _imageBytes = base64.decode(reader.result.toString().split(',').last);
        });
      });
    }
  }
  Future<void> _caricaImmagine(Uint8List? _imageBytes) async {
    if (_imageBytes == null) {
      return;
    }

    http.Response response = await Model().caricaImmagine(_imageBytes, widget.indice + 1);

    if (response.statusCode == 200) {
      widget.domanda.url_immagine = response.body;
      //widget.immagini.add(widget.indice.toString());
      // La richiesta ha avuto successo
      showDialog(
        context: context,
        builder: (context) =>
            MessaggioDialogo(
              titleText: "Perfetto",
              bodyText: "Immagine caricata con successo",
            ),
      );
      setState(() {
        _giaCaricata = true;
      });
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

  Future<void> _deleteImage() async {
    List<String> parti = widget.domanda.url_immagine.split('/');
    String fileName = parti.last;
    http.Response response = await Model().eliminaImmagine(fileName);
    if (response.statusCode == 200) {
      widget.domanda.url_immagine = "NO";
      //widget.immagini.add(widget.indice.toString());
      // La richiesta ha avuto successo
      showDialog(
        context: context,
        builder: (context) =>
            MessaggioDialogo(
              titleText: "Perfetto",
              bodyText: "Immagine rimossa con successo",
            ),
      );
      setState(() {
        _imageBytes = null;
        _giaCaricata = false;
      });
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
    //widget.immagini.remove(widget.indice.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Text('Domanda ${widget.indice + 1}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: widget.onDelete,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: TextFormField(
              controller: _domandaController,
              decoration: InputDecoration(
                labelText: 'Testo della Domanda',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                widget.domanda.domanda = value;
              },
            ),
          ),

          Column(
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _pickImage,
                          child: Text('Seleziona immagine', style: TextStyle(fontSize: 15)),
                          style: ElevatedButton.styleFrom(
                             backgroundColor: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
              ),
              if (_imageBytes != null)
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.memory(_imageBytes!, height: 150), // Ridimensionamento dell'immagine
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                      child: Row (
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Expanded(
                          child:ElevatedButton(
                            onPressed: _deleteImage,
                            child: Text('Elimina immagine', style: TextStyle(fontSize: 15)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child:
                          ElevatedButton(
                            onPressed: (_imageBytes != null && !_giaCaricata) ? () {
                              // Qui puoi implementare il caricamento dell'immagine su S3
                              _caricaImmagine(_imageBytes!);
                            } : null,
                            child: Text('Carica immagine nel cloud', style: TextStyle(fontSize: 15)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              // Per cambiare il colore del pulsante quando è disabilitato
                              onSurface: Colors.green.withOpacity(0.5),
                            ),
                          ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Quante risposte alla domanda vuoi fornire?',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            _generateAnswers(int.parse(value));
                          }
                        },
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_forever),
                      onPressed: _resetAnswers,
                    ),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.controllers.length,
                itemBuilder: (context, answerIndex) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: widget.controllers[answerIndex],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: '${answerIndex + 1}° risposta',
                            ),
                            onChanged: (value) {
                              setState(() {
                                widget.domanda.risposte[answerIndex] = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 12.0),
            ],
          ),
        ],
      ),
    );
  }
}