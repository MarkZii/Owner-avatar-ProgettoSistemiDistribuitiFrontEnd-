class Risposta2 {
  String domanda;
  String scelte;

  Risposta2({
    required this.domanda,
    required this.scelte
  });

  factory Risposta2.fromJson(Map<String, dynamic> json) {

    return Risposta2(
        domanda: json['domanda'],
        scelte: json['scelte']
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