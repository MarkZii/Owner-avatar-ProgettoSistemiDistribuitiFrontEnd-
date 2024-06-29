import 'Domanda.dart';

class Questionario {
  String id_questionario;
  String nome_autore;
  String data_ora;
  String titolo;
  String descrizione;
  List<Domanda> domande;


  Questionario({
    required this.id_questionario,
    required this.nome_autore,
    required this.data_ora,
    required this.titolo,
    required this.descrizione,
    required this.domande});

  factory Questionario.fromJson(Map<String, dynamic> json) {

    var itemList = json['domande'] as List;
    List<Domanda> dom = itemList.map((domanda) => Domanda.fromJson(domanda)).toList();

    return Questionario(
        id_questionario: json['id_questionario'],
        nome_autore: json['nome_autore'],
        data_ora: json['data_ora'],
        titolo: json['titolo'],
        descrizione: json['descrizione'],
        domande: dom
    );
  }

  Map<String, dynamic> toJson() => {
    'id_questionario': id_questionario,
    'nome_autore': nome_autore,
    'data_ora': data_ora,
    'titolo': titolo,
    'descrizione': descrizione,
    'domande': domande.map((domanda) => domanda.toJson()).toList()
  };

  @override
  String toString() {
    return id_questionario+" "+nome_autore+" "+titolo+" "+descrizione;
  }
}