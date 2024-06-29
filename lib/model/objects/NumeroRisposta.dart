class NumeroRisposta {
  String risposta;
  int numero;


  NumeroRisposta({ required this.risposta, required this.numero});

  factory NumeroRisposta.fromJson(Map<String, dynamic> json) {

    return NumeroRisposta(
      risposta: json['risposta'],
      numero: json['numero'],
    );
  }

  Map<String, dynamic> toJson() => {
    'risposta': risposta,
    'numero': numero,
  };

  @override
  String toString() {
    return risposta+" "+numero.toString();
  }
}