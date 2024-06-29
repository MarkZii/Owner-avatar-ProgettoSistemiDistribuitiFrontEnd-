import 'Risposta.dart';

class Compilazione {
  String nome_utente;
  String id_questionario;
  String data_ora;
  List<Risposta> risposte;


  Compilazione({
    //required this.id_compilazione,
    required this.nome_utente,
    required this.data_ora,
    required this.id_questionario,
    required this.risposte});

  factory Compilazione.fromJson(Map<String, dynamic> json) {

    var itemList = json['risposte'] as List;
    List<Risposta> risp = itemList.map((risposta) => Risposta.fromJson(risposta)).toList(); // Modifica: corretta la conversione delle risposte


    return Compilazione(
        //id_compilazione: json['id_compilazione'],
        nome_utente: json['nome_utente'],
        data_ora: json['data_ora'],
        id_questionario: json['id_questionario'],
        risposte: risp
    );
  }

  Map<String, dynamic> toJson() => {
    //'id_compilazione': id_compilazione,
    'nome_utente': nome_utente,
    'data_ora': data_ora,
    'id_questionario': id_questionario,
    'risposte': risposte.map((risposta) => risposta.toJson()).toList(),
  };

  @override
  String toString() {
    return nome_utente+""+id_questionario+""+risposte.toString();
  }
}