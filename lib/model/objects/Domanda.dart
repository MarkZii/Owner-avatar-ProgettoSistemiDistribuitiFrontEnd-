class Domanda {
  String domanda;
  List<String> risposte;
  String url_immagine;


  Domanda({ required this.domanda, required this.risposte, required this.url_immagine});

  factory Domanda.fromJson(Map<String, dynamic> json) {

    var itemList = json['risposte'] as List;
    List<String> risp = itemList.map((risposta) => risposta.toString()).toList(); // Modifica: corretta la conversione delle risposte
    // print(json['domanda']);
    // print(json['risposte']);
    // print(json['url_immagine']);
    return Domanda(
        domanda: json['domanda'],
        risposte: risp,
      url_immagine: json['url_immagine'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'domanda': domanda,
    'risposte': risposte,
    'url_immagine': url_immagine.isEmpty ? "NO" : url_immagine,
  };

  @override
  String toString() {
    return domanda+" "+url_immagine+" "+risposte.toString();
  }
}