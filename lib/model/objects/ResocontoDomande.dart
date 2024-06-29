import 'NumeroRisposta.dart';

class ResocontoDomande {
  String domanda;
  List<NumeroRisposta> numeroRisposta;
  String url_immagine;


  ResocontoDomande({
    required this.domanda,
    required this.numeroRisposta,
    required this.url_immagine});

  factory ResocontoDomande.fromJson(Map<String, dynamic> json) {

    var itemList = json['numeroRisposta'] as List;
    List<NumeroRisposta> risposte = itemList.map((risposta) => NumeroRisposta.fromJson(risposta)).toList(); // Modifica: corretta la conversione delle risposte

    return ResocontoDomande(
      domanda: json['domanda'],
      numeroRisposta: risposte,
      url_immagine: json['url_immagine'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'domanda': domanda,
    'numeroRisposta': numeroRisposta,
    'url_immagine': url_immagine.isEmpty ? "NO" : url_immagine,
  };

  @override
  String toString() {
    return domanda+" "+url_immagine+" "+numeroRisposta.toString();
  }
}