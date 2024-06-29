class Constants {
  // app info
  static final String APP_VERSION = "0.0.1";
  static final String APP_NAME = "Questionari Online";

  // addresses
  static final String ADDRESS_ECOMMERCE_SERVER = "http://backendquestionarionline-env.eba-bwrhwg9u.eu-north-1.elasticbeanstalk.com";

  // authentication
  static final String REALM = "Questionari Online";

  // Richieste COMPILAZIONE
  static final String RICHIESTA_SALVA_COMPILAZIONE = "/compilazione/salva";
  static final String RICHIESTA_RECUPERA_COMPILAZIONE = "/compilazione/recupera";
  static final String RICHIESTA_TUTTI_COMPILAZIONE = "/compilazione/tutti";
  static final String RICHIESTA_ELIMINA_COMPILAZIONE = "/compilazione/elimina";
  static final String RICHIESTA_RICERCA_COMPILAZIONE = "/compilazione/ricercaCompilazioni";
  static final String RICHIESTA_COMPILAZIONI_DISPONIBILI = "/compilazione/disponibili";

  // Richieste EMAIL
  static final String RICHIESTA_INVIO_EMAIL = "/email/invio";
  static final String RICHIESTA_INVIO_EMAIL_TUTTI = "/email/invii";

  // Richieste IMMAGINI
  static final String RICHIESTA_CARICA_IMMAGINI = "/immagini/carica";
  static final String RICHIESTA_DOWNLOADNOME_IMMAGINI = "/immagini/downloadNome";
  static final String RICHIESTA_DOWNLOADURI_IMMAGINI = "/immagini/downloadURI";
  static final String RICHIESTA_ELIMINA_IMMAGINI = "/immagini/elimina";

  // Richieste QUESTIONARI
  static final String RICHIESTA_SALVA_QUESTIONARI = "/questionari/salva";
  static final String RICHIESTA_RECUPERA_QUESTIONARI = "/questionari/recupera";
  static final String RICHIESTA_TUTTI_QUESTIONARI = "/questionari/tutti";
  static final String RICHIESTA_ELIMINA_QUESTIONARI = "/questionari/elimina";

  // Richieste UTENTE
  static final String RICHIESTA_INFORMAZIONI_UTENTE = "/utente/informazioni2";
  static final String RICHIESTA_LOGIN_UTENTE = "/utente/login";
  static final String RICHIESTA_REGISTRAZIONE_UTENTE = "/utente/registrazione";
  static final String RICHIESTA_TUTTI_UTENTI = "/utente/utenti";

  // Richieste RISULTATI
  static final String RICHIESTA_RISULTATI_UTENTI = "/risultati/tutti";


  // responses
  static final String RESPONSE_ERROR_MAIL_USER_ALREADY_EXISTS = "Errore: la mail usata esiste";
  static final String RESPONSE_ERROR_KEYCLOAK = "Errore server interno";

  // messages
  static final String MESSAGE_CONNECTION_ERROR = "connection_error";
  static final String ERROR_DATE_INVALID="ERROR_INVALID_DATE";
  static final String ERROR_BOOKING_UNAVAILABLE="ERROR_BOOKING_UNAVAILABLE";

  // links
  static final String LINK_RESET_PASSWORD = "***";
  static final String LINK_FIRST_SETUP_PASSWORD = "***";

}