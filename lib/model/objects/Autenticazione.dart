class Autenticazione {
  String accessToken;
  String refreshToken;
  String idToken;


  Autenticazione({required this.accessToken, required this.refreshToken, required this.idToken});

  factory Autenticazione.fromJson(Map<String, dynamic> json) {
    return Autenticazione(
      accessToken: json['AccessToken'],
      refreshToken: json['RefreshToken'],
      idToken: json['IdToken'],
    );
  }
  @override
  String toString() {
    return accessToken+" "+refreshToken+" "+idToken;
  }

  String getAccessToken(){
    return accessToken;
  }
}