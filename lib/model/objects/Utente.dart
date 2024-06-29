class Utente {
  final String username;
  final String email;

  Utente({required this.username, required this.email});

  factory Utente.fromJson(Map<String, dynamic> json) {
    return Utente(
      username: json['username'],
      email: json['email'],
    );
  }
}