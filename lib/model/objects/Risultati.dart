
import 'ResocontoDomande.dart';

class Risultati {
  String id_risultato;
  String nome_autore;
  String data_ora;
  String titolo;
  String descrizione;
  int durata;
  int numeroRisposte;
  List<ResocontoDomande> resocontoDomande;


  Risultati({
    required this.id_risultato,
    required this.nome_autore,
    required this.data_ora,
    required this.titolo,
    required this.descrizione,
    required this.durata,
    required this.numeroRisposte,
    required this.resocontoDomande});

  factory Risultati.fromJson(Map<String, dynamic> json) {

    var itemList = json['resocontoDomande'] as List;
    List<ResocontoDomande> resoconto = itemList.map((resoconto) => ResocontoDomande.fromJson(resoconto)).toList();

    return Risultati(
        id_risultato: json['id_risultato'],
        nome_autore: json['nome_autore'],
        data_ora: json['data_ora'],
        titolo: json['titolo'],
        descrizione: json['descrizione'],
        durata: json['durata'],
        numeroRisposte: json['numeroRisposte'],
        resocontoDomande: resoconto
    );
  }

  Map<String, dynamic> toJson() => {
    'id_risultato': id_risultato,
    'nome_autore': nome_autore,
    'data_ora': data_ora,
    'titolo': titolo,
    'descrizione': descrizione,
    'durata': durata,
    'numeroRisposte': numeroRisposte,
    'resocontoDomande': resocontoDomande.map((resocontoDomande) => resocontoDomande.toJson()).toList()
  };

  @override
  String toString() {
    return id_risultato+" "+nome_autore+" "+titolo+" "+descrizione;
  }
}
