class Risposta {
  String domanda;
  List<String> scelte;

  Risposta({
    required this.domanda,
    required this.scelte
  });

  factory Risposta.fromJson(Map<String, dynamic> json) {
    var itemList = json['scelte'] as List;
    List<String> risp = itemList.map((scelta) => scelta.toString()).toList(); // Modifica: corretta la conversione delle risposte

    return Risposta(
        domanda: json['domanda'],
        scelte: risp
    );
  }

  Map<String, dynamic> toJson() => {
    'domanda': domanda,
    'scelte': scelte
  };

  @override
  String toString() {
    return domanda+""+scelte.toString();
  }
}