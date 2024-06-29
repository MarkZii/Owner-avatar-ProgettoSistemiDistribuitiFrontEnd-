import 'dart:async';
import 'dart:convert';
import 'package:frontendsistemidistribuitiprogetto/model/objects/Questionario.dart';
import 'package:frontendsistemidistribuitiprogetto/model/objects/Risultati.dart';

import '../support/Constants.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:typed_data';

import '../support/LogInResult.dart';
import 'objects/Autenticazione.dart';


class Model {
  static Model sharedInstance = Model();
  static String _userAccessToken = "";
  static String utente = "";

  Autenticazione? _authenticationData;

  //GESTIONE QUESTIONARI
  Future<http.Response> caricaQuestionario(Map<String, dynamic> questionarioCompleto) async {
    Uri uri = Uri.parse(Constants.ADDRESS_ECOMMERCE_SERVER+""+Constants.RICHIESTA_SALVA_QUESTIONARI);

    questionarioCompleto.update("nome_autore", (value) => utente);
    try {
      var response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + _userAccessToken!,
        },
        body: jsonEncode(questionarioCompleto),
      );

      return response;
    } catch (e) {
      throw Exception('Caricamento fallito');
    }
  }
  // Future<List<Questionario>> visualizzaQuestionariTuttti() async {
  //   Map<String, String> params = Map();
  //   try {
  //     String lista = await _restManager.makeGetRequest(Constants.ADDRESS_ECOMMERCE_SERVER, Constants.RICHIESTA_TUTTI_QUESTIONARI, params);
  //     //String lista = '''[{"id_risultato":"e852ffad-882b-4175-a15c-7ed1aecafe8d","nome_autore":"giusy","data_ora":"sabato 29 giugno 2024, 00:42","titolo":"Stile di Vita degli Italiani","descrizione":"Questo questionario esplora vari aspetti dello stile di vita degli italiani, dalle abitudini quotidiane alle preferenze culturali e alimentari. Le risposte raccolte forniranno un’istantanea delle tendenze e dei comportamenti tipici in Italia.","numeroRisposte":0,"resocontoDomande":[{"domanda":"Quali tra questi sono per te i pasti più importanti della giornata?","numeroRisposta":[{"risposta":"Colazione","numero":0},{"risposta":"Pranzo","numero":0},{"risposta":"Cena","numero":0},{"risposta":"Spuntino","numero":0}],"url_immagine":"NO"},{"domanda":"Quanto spesso frequenti ristoranti o pizzerie?","numeroRisposta":[{"risposta":"Una volta alla settimana","numero":0},{"risposta":"Due o tre volte al mese","numero":0},{"risposta":"Solo in occasioni speciali","numero":0},{"risposta":"Più volte alla settimana","numero":0}],"url_immagine":"NO"},{"domanda":"Quali sono i mezzi di trasporto che utilizzi maggiormente per gli spostamenti quotidiani?","numeroRisposta":[{"risposta":"Automobile","numero":0},{"risposta":"Bicicletta","numero":0},{"risposta":"Autobus","numero":0},{"risposta":"Treno","numero":0},{"risposta":"A piedi","numero":0},{"risposta":"Taxi","numero":0}],"url_immagine":"NO"},{"domanda":"Quanto tempo dedichi, in media, all’attività fisica ogni settimana?","numeroRisposta":[{"risposta":"Meno di un’ora","numero":0},{"risposta":"Da una a due ore","numero":0},{"risposta":"Da tre a cinque ore","numero":0},{"risposta":"Più di cinque ore","numero":0}],"url_immagine":"NO"},{"domanda":"Come preferisci trascorrere il tempo libero?","numeroRisposta":[{"risposta":"Guardando la televisione o film","numero":0},{"risposta":"Leggendo libri o giornali","numero":0},{"risposta":"Socializzando con amici e familiari","numero":0},{"risposta":"Praticando sport o attività all’aperto","numero":0}],"url_immagine":"NO"},{"domanda":"Quali sono le bevande che preferisci consumare durante una pausa caffè?","numeroRisposta":[{"risposta":"Cioccolata calda","numero":0},{"risposta":"Tè freddo","numero":0},{"risposta":"Cappuccino","numero":0},{"risposta":"Espresso","numero":0},{"risposta":"Tè caldo","numero":0}],"url_immagine":"NO"}]},{"id_risultato":"3ab93350-4429-4735-94d3-2f4b930fc667","nome_autore":"giusy","data_ora":"sabato 29 giugno 2024, 00:42","titolo":"Questionario sulle Abitudini Tecnologiche","descrizione":"Questo questionario mira a esplorare le tue abitudini e preferenze nell’uso della tecnologia. Le risposte fornite ci aiuteranno a comprendere meglio come le persone utilizzano dispositivi tecnologici e servizi digitali. Rispondi alle seguenti sei domande selezionando l’opzione che meglio rappresenta le tue abitudini.","numeroRisposte":0,"resocontoDomande":[{"domanda":"Quanto tempo trascorri in media al giorno usando dispositivi elettronici (computer, smartphone, tablet, ecc.)?","numeroRisposta":[{"risposta":"Più di 8 ore","numero":0},{"risposta":"4-8 ore","numero":0},{"risposta":" 2-4 ore","numero":0},{"risposta":"Meno di 2 ore","numero":0}],"url_immagine":"NO"},{"domanda":"Qual è il tuo dispositivo tecnologico preferito?","numeroRisposta":[{"risposta":"Smartphone","numero":0},{"risposta":"Computer portatile","numero":0},{"risposta":"Tablet","numero":0},{"risposta":"Smartwatch o altri dispositivi indossabili","numero":0}],"url_immagine":"s3://immaginiquestionario/1719612506229_Domanda 2.jpg"},{"domanda":"Quanto spesso aggiorni o sostituisci i tuoi dispositivi tecnologici?","numeroRisposta":[{"risposta":"Ogni anno o meno","numero":0},{"risposta":"Ogni 2-3 anni","numero":0},{"risposta":"Ogni 4-5 anni","numero":0},{"risposta":"Solo quando è assolutamente necessario","numero":0}],"url_immagine":"NO"},{"domanda":"Come preferisci acquisire nuovi software o applicazioni?","numeroRisposta":[{"risposta":"Download da app store ufficiali","numero":0},{"risposta":"Software libero o open source","numero":0},{"risposta":"Software aziendale o raccomandato da lavoro","numero":0},{"risposta":"Non scarico spesso nuovi software o app","numero":0}],"url_immagine":"NO"},{"domanda":"Quanto sei preoccupato/a per la sicurezza dei tuoi dati personali online?","numeroRisposta":[{"risposta":"Molto, prendo molte precauzioni","numero":0},{"risposta":"Abbastanza, ma non sono ossessionato/a","numero":0},{"risposta":"Poco, ma cerco di essere prudente","numero":0},{"risposta":"Per niente, non ci penso mai","numero":0}],"url_immagine":"1719612802465_Domanda 5.jpg rimosso con successo."},{"domanda":"Quanto spesso usi la tecnologia per la comunicazione (social media, email, messaggistica, ecc.)?","numeroRisposta":[{"risposta":"Continuamente, ogni giorno","numero":0},{"risposta":"Spesso, più volte alla settimana","numero":0},{"risposta":"Raramente, solo quando necessario","numero":0},{"risposta":"Quasi mai","numero":0}],"url_immagine":"NO"}]},{"id_risultato":"19c6c430-a369-4e55-8929-88752b86107e","nome_autore":"frankrossi","data_ora":"sabato 29 giugno 2024, 00:42","titolo":"Questionario sulle Abitudini di Lettura","descrizione":"Questo questionario è progettato per capire meglio le tue abitudini di lettura. Le tue risposte ci aiuteranno a comprendere quanto spesso e cosa leggi. Rispondi alle seguenti domande selezionando l’opzione che meglio ti descrive.","numeroRisposte":0,"resocontoDomande":[{"domanda":"Quanto spesso leggi libri per piacere?","numeroRisposta":[{"risposta":"Ogni giorno","numero":0},{"risposta":"Più volte alla settimana","numero":0},{"risposta":"Una volta al mese","numero":0},{"risposta":"Raramente o mai","numero":0}],"url_immagine":"NO"},{"domanda":"Quale genere di libri preferisci leggere?","numeroRisposta":[{"risposta":"Narrativa (romanzi, racconti, ecc.)","numero":0},{"risposta":"Saggistica (biografie, storia, scienza, ecc.)","numero":0},{"risposta":"Libri di auto-aiuto o crescita personale","numero":0},{"risposta":"Libri professionali o accademici","numero":0}],"url_immagine":"s3://immaginiquestionario/1719610276372_Domanda 2.jpg"},{"domanda":"Dove preferisci leggere i tuoi libri?","numeroRisposta":[{"risposta":"In casa, in un ambiente tranquillo","numero":0},{"risposta":"In viaggio (mezzi pubblici, aereo, ecc.)","numero":0},{"risposta":"In luoghi pubblici (caffetterie, parchi, ecc.)","numero":0},{"risposta":"Ovunque, non ho un posto preferito","numero":0}],"url_immagine":"NO"},{"domanda":"Come preferisci leggere i tuoi libri?","numeroRisposta":[{"risposta":"Formato cartaceo","numero":0},{"risposta":"E-book su un dispositivo elettronico","numero":0},{"risposta":"Audiolibri","numero":0},{"risposta":"Un mix di formati, dipende dalla situazione","numero":0}],"url_immagine":"s3://immaginiquestionario/1719610571210_Domanda 4.jpg"},{"domanda":"Quanto tempo dedichi alla lettura ogni settimana?","numeroRisposta":[{"risposta":"Più di 10 ore","numero":0},{"risposta":"5-10 ore","numero":0},{"risposta":"1-4 ore","numero":0},{"risposta":"Meno di 1 ora","numero":0}],"url_immagine":"NO"},{"domanda":"Quanto ti influenzano le recensioni o le raccomandazioni nella scelta dei libri?","numeroRisposta":[{"risposta":"Molto, leggo solo libri ben recensiti o consigliati","numero":0},{"risposta":"Abbastanza, mi aiutano a decidere cosa leggere","numero":0},{"risposta":"Poco, preferisco scegliere da solo/a","numero":0},{"risposta":"Per niente, non mi baso mai su recensioni o consigli","numero":0}],"url_immagine":"NO"}]},{"id_risultato":"aefc5a90-5566-4ef1-b2ff-24c84356d7d3","nome_autore":"giusy","data_ora":"sabato 29 giugno 2024, 00:42","titolo":"Questionario sulle Abitudini Alimentari","descrizione":"Questo questionario ha lo scopo di comprendere meglio le tue abitudini alimentari quotidiane. Le risposte che fornirai ci aiuteranno a identificare i modelli comuni di dieta e preferenze alimentari. Ti preghiamo di selezionare la risposta che meglio rappresenta le tue abitudini.","numeroRisposte":0,"resocontoDomande":[{"domanda":"Quanto spesso consumi pasti fuori casa (ristoranti, fast food, take-away, ecc.)?","numeroRisposta":[{"risposta":"Quasi mai (meno di una volta al mese)","numero":0},{"risposta":"Qualche volta (1-3 volte al mese)","numero":0},{"risposta":"Spesso (1-2 volte alla settimana)","numero":0},{"risposta":"Molto spesso (più di 3 volte alla settimana)","numero":0}],"url_immagine":"NO"},{"domanda":"Qual è la tua fonte principale di pasti?","numeroRisposta":[{"risposta":"Preparo e cucino a casa","numero":0},{"risposta":"Compro cibo pronto al supermercato","numero":0},{"risposta":"Mangio principalmente in ristoranti o ordino da asporto","numero":0},{"risposta":"Vado a casa di amici o parenti per i pasti","numero":0}],"url_immagine":"NO"},{"domanda":"Quanto spesso consumi frutta e verdura fresche?","numeroRisposta":[{"risposta":"Ogni giorno","numero":0},{"risposta":"3-4 volte alla settimana","numero":0},{"risposta":"1-2 volte alla settimana","numero":0},{"risposta":"Raramente o mai","numero":0}],"url_immagine":"NO"},{"domanda":"Qual è il tuo principale motivo per scegliere certi alimenti?","numeroRisposta":[{"risposta":"Salute e valori nutrizionali","numero":0},{"risposta":"Prezzo e convenienza","numero":0},{"risposta":"Gusto e piacere personale","numero":0},{"risposta":"Facilità e velocità di preparazione","numero":0}],"url_immagine":"NO"},{"domanda":"Quanto spesso includi proteine animali (carne, pesce, uova) nella tua dieta?","numeroRisposta":[{"risposta":"Ad ogni pasto","numero":0},{"risposta":"La maggior parte dei giorni","numero":0},{"risposta":"Occasionalmente (1-2 volte alla settimana)","numero":0},{"risposta":"Raramente o mai (seguo una dieta vegetariana/vegana)","numero":0}],"url_immagine":"NO"},{"domanda":"Come descriveresti la tua abitudine al consumo di bevande zuccherate (succhi, soda, ecc.)?","numeroRisposta":[{"risposta":"Non le consumo mai","numero":0},{"risposta":"Le consumo raramente (meno di una volta alla settimana)","numero":0},{"risposta":"Le consumo spesso (2-3 volte alla settimana)","numero":0},{"risposta":"Le consumo quotidianamente","numero":0}],"url_immagine":"NO"}]},{"id_risultato":"d66ec6e9-e5bc-4397-a539-b2a0cb223b01","nome_autore":"salvebrett","data_ora":"sabato 29 giugno 2024, 00:42","titolo":"Questionario sulle Abitudini di Viaggio","descrizione":"Questo questionario intende esplorare le tue preferenze e abitudini di viaggio. Le tue risposte ci aiuteranno a capire come e perché le persone viaggiano. Rispondi alle seguenti sei domande selezionando l’opzione che meglio rappresenta le tue abitudini.","numeroRisposte":0,"resocontoDomande":[{"domanda":"Quanto spesso viaggi per piacere (vacanze, tempo libero)?","numeroRisposta":[{"risposta":"Più di due volte all’anno","numero":0},{"risposta":"Una o due volte all’anno","numero":0},{"risposta":"Raramente (meno di una volta all’anno)","numero":0},{"risposta":"Quasi mai","numero":0}],"url_immagine":"s3://immaginiquestionario/1719614329473_Domanda 1.jpg"},{"domanda":"Qual è il tuo mezzo di trasporto preferito per viaggiare?","numeroRisposta":[{"risposta":"Treno","numero":0},{"risposta":"Aereo","numero":0},{"risposta":"Macchina","numero":0},{"risposta":"Nave","numero":0},{"risposta":"Bici","numero":0}],"url_immagine":"s3://immaginiquestionario/1719614562010_Domanda 2.jpg"},{"domanda":"Dove preferisci alloggiare durante i tuoi viaggi?","numeroRisposta":[{"risposta":"Hotel di lusso","numero":0},{"risposta":"Bed & Breakfast o piccoli alberghi","numero":0},{"risposta":"Affitti a breve termine (Airbnb, case vacanze, ecc.)","numero":0},{"risposta":"Campeggi o ostelli","numero":0}],"url_immagine":"s3://immaginiquestionario/1719614399340_Domanda 3.jpg"},{"domanda":"Quanto spesso pianifichi i tuoi viaggi con largo anticipo?","numeroRisposta":[{"risposta":"Sempre, con mesi di anticipo","numero":0},{"risposta":"Spesso, con alcune settimane di anticipo","numero":0},{"risposta":"A volte, con pochi giorni di anticipo","numero":0},{"risposta":"Raramente, viaggio spontaneamente","numero":0}],"url_immagine":"NO"},{"domanda":"Qual è il principale motivo per cui viaggi?","numeroRisposta":[{"risposta":"Scoprire nuove culture e paesaggi","numero":0},{"risposta":"Rilassarmi e staccare dalla routine","numero":0},{"risposta":"Visitare amici e parenti","numero":0},{"risposta":"Partecipare a eventi o per motivi di lavoro","numero":0}],"url_immagine":"NO"},{"domanda":"Quanto ti piace sperimentare la cucina locale quando viaggi?","numeroRisposta":[{"risposta":"Sempre, è una parte fondamentale del viaggio","numero":0},{"risposta":"Spesso, mi piace provare nuovi piatti","numero":0},{"risposta":"Qualche volta, ma preferisco cibi familiari","numero":0},{"risposta":"Raramente, preferisco cibo che conosco bene","numero":0}],"url_immagine":"NO"}]}]''';
  //     List<Questionario> lista2 = List<Questionario>.from(json.decode(lista).map((i) => Questionario.fromJson(i)).toList());
  //     print(lista2);
  //
  //     // Map<String, dynamic> parsedJson = json.decode(lista);
  //     // Questionario questionario = Questionario.fromJson(parsedJson);
  //     // List<Questionario> questionariList = [questionario];
  //     // print(questionariList);
  //
  //     return lista2;
  //   }
  //   catch (e) {
  //     return []; // not the best solution
  //   }
  // }
  Future<List<Questionario>> visualizzaQuestionariTutti() async {
    Uri uri = Uri.parse(Constants.ADDRESS_ECOMMERCE_SERVER+""+Constants.RICHIESTA_TUTTI_QUESTIONARI);
    try {
      var response = await http.get(
        uri,
        // headers: <String, String>{
        //   'Authorization': 'Bearer ' + _userAccessToken!,
        // },
      );
      String lista = response.body;
      List<Questionario> lista2 = List<Questionario>.from(json.decode(lista).map((i) => Questionario.fromJson(i)).toList());
      print(lista2);
      return lista2;
    } catch (e) {
      throw Exception('Caricamento fallito'+e.toString());
    }
  }

  //GESTIONE COMPILAZIONE
  Future<List<Questionario>> questionariDisponibili() async {
    Uri uri = Uri.parse(Constants.ADDRESS_ECOMMERCE_SERVER+""+Constants.RICHIESTA_COMPILAZIONI_DISPONIBILI+"?nome_utente="+utente);
    try {
      var response = await http.get(
        uri,
        headers: <String, String>{
          'Authorization': 'Bearer ' + _userAccessToken!,
        },
      );
      String lista = response.body;
      //String lista = '''[{ "id_questionario": "59935831-baff-4c15-853e-3cd53f336075", "nome_autore": "giusy", "data_ora": "venerdì 28 giugno 2024, 16:20", "descrizione": "ccc", "domande": [ { "domanda": "fgjhdfgj", "risposte": [ "ghh", "g", "ghhjgc", "jukiulk" ], "url_immagine": "NO" }, { "domanda": "fghdhdg", "risposte": [ "hgjdcxsgth", "xxxxxvc" ], "url_immagine": "NO" } ], "titolo": "hhh" }, { "id_questionario": "1c792b37-b4b3-4cfa-9506-b9a5c33d5ba7", "nome_autore": "giusy", "data_ora": "giovedì 27 giugno 2024, 23:53", "titolo": "Questionario di Valutazione delle Conoscenze di Biologia Vegetale", "descrizione": "Questo questionario ha lo scopo di valutare le tue conoscenze sulla biologia delle piante. Le domande coprono vari aspetti della struttura e della funzione delle piante. Per ogni domanda, seleziona la risposta che ritieni corretta tra le opzioni fornite.", "domande": [ { "domanda": "Osserva l'immagine seguente e identifica il tipo di foglia mostrato:", "risposte": [ "Foglia palmata", "Foglia pennata", "Foglia aghiforme", "Foglia cuoriforme" ], "url_immagine": "s3://immaginiquestionario/1719523487318_Domanda 1.jpg" }, { "domanda": "Quale tra le seguenti è una funzione principale delle radici nelle piante?", "risposte": [ "Fotosintesi", "Assorbimento di acqua e nutrienti", "Produzione di frutti", "Impollinazione" ], "url_immagine": "" }, { "domanda": "Qual è il processo mediante il quale l'acqua si muove dalle radici alle foglie nelle piante?", "risposte": [ "Traslocazione", "Traspirazione", "Osmosi", "Diffusione" ], "url_immagine": "" }, { "domanda": "Osserva l'immagine seguente e identifica la parte della pianta mostrata:", "risposte": [ "Frutto", "Fiore", "Foglia", "Radice" ], "url_immagine": "s3://immaginiquestionario/radice.png" } ], "titolo": "Questionario di Valutazione delle Conoscenze di Biologia Vegetale" }, { "id_questionario": "33d71325-4142-47d3-9c58-a60fa45e567a", "nome_autore": "frankrossi", "data_ora": "giovedì 27 giugno 2024, 23:53", "titolo": "Questionario di Valutazione delle Competenze Informatiche", "descrizione": "Questo questionario ha lo scopo di valutare le tue competenze in ambito informatico. Le domande spaziano da concetti di base a argomenti più avanzati. Per ogni domanda, seleziona la risposta che ritieni corretta tra le opzioni fornite.", "domande": [ { "domanda": "Qual è il linguaggio di programmazione più utilizzato per lo sviluppo web front-end?", "risposte": [ "Java", "Python", "JavaScript", "C++" ], "url_immagine": "" }, { "domanda": "Quale tra i seguenti è un sistema operativo open-source?", "risposte": [ "Windows 10", "macOS", "Linux", "iOS" ], "url_immagine": "" }, { "domanda": "Qual è la funzione principale di un database management system (DBMS)?", "risposte": [ "Creare siti web", "Memorizzare e gestire dati", "Analizzare big data", "Compilare programmi" ], "url_immagine": "" }, { "domanda": "Quale delle seguenti opzioni descrive meglio il concetto di 'cloud computing'?", "risposte": [ "Utilizzo di server locali per l'archiviazione dei dati", "Esecuzione di processi di calcolo su dispositivi personali", "Fornitura di servizi di calcolo e archiviazione attraverso internet", "Programmazione di applicazioni desktop" ], "url_immagine": "" }, { "domanda": "Cos'è un 'firewall' in ambito informatico?", "risposte": [ "Un dispositivo che raffredda i componenti del computer", "Un software che protegge i dati da accessi non autorizzati", "Un tipo di malware", "Un algoritmo di compressione dati" ], "url_immagine": "" }, { "domanda": "Osserva l'immagine seguente e indica quale tipo di rete rappresenta:", "risposte": [ "Rete a stella", "Rete ad anello", "Rete a maglia", "Rete a bus" ], "url_immagine": "s3://immaginiquestionario/1719521634093_Domanda 3.jpg" } ], "titolo": "Questionario di Valutazione delle Competenze Informatiche" }, { "id_questionario": "b3b3be89-c8eb-4204-89f2-7e12d44bf586", "nome_autore": "giusy", "data_ora": "giovedì 27 giugno 2024, 23:53", "titolo": "Questionario di Valutazione delle Conoscenze di Biologia Cellulare", "descrizione": "Questo questionario ha lo scopo di valutare le tue conoscenze sulle diverse parti della cellula. Ogni domanda include un'immagine di una cellula o di una sua parte specifica. Per ogni domanda, osserva attentamente l'immagine e seleziona la risposta corretta tra le opzioni fornite.", "domande": [ { "domanda": "Che cosa è rappresentato nella figura?", "risposte": [ "Mitocondrio", "Nucleo", "Reticolo endoplasmatico", "Apparato del Golgi" ], "url_immagine": "s3://immaginiquestionario/1719522552904_Domanda 1.jpg" }, { "domanda": "Che cosa è rappresentato nella figura?", "risposte": [ "Lisosoma", "Mitocondrio", "Cloroplasto", "Ribosoma" ], "url_immagine": "s3://immaginiquestionario/1719522725698_Domanda 2.jpg" }, { "domanda": "Che cosa è rappresentato nella figura?", "risposte": [ "Apparato del Golgi", "Reticolo endoplasmatico rugoso", "Reticolo endoplasmatico liscio", "Nucleolo" ], "url_immagine": "s3://immaginiquestionario/1719522870145_Domanda 3.jpg" }, { "domanda": "Che cosa è rappresentato nella figura?", "risposte": [ "Ribosomi", "Lisosomi", "Nucleo", "Cloroplasto" ], "url_immagine": "s3://immaginiquestionario/1719523221796_Domanda 4.jpg" } ], "titolo": "Questionario di Valutazione delle Conoscenze di Biologia Cellulare" }, { "id_questionario": "a46707c6-286e-4272-9de7-6f9c5f54e9c0", "nome_autore": "salvebrett", "data_ora": "giovedì 27 giugno 2024, 23:53", "titolo": "Questionario di Valutazione delle Conoscenze Giuridiche", "descrizione": "Questo questionario ha lo scopo di valutare le tue conoscenze in ambito giuridico. Le domande coprono vari aspetti della legge e del sistema giuridico. Per ogni domanda, seleziona la risposta che ritieni corretta tra le opzioni fornite.", "domande": [ { "domanda": "Quale tra i seguenti è il massimo organo giurisdizionale in Italia?", "risposte": [ "Corte d'Appello", "Tribunale di primo grado", "Corte Costituzionale", "Consiglio di Stato" ], "url_immagine": "" }, { "domanda": "Qual è la funzione principale della Costituzione di uno Stato?", "risposte": [ "Regolare i rapporti economici", "Stabilire le regole per le elezioni", "Definire i diritti e i doveri dei cittadini e le strutture fondamentali del governo", "Gestire le relazioni internazionali" ], "url_immagine": "" }, { "domanda": "Quale tra i seguenti è un diritto fondamentale riconosciuto dalla Costituzione italiana?", "risposte": [ "Diritto al lavoro", "Diritto all'assistenza legale gratuita", "Diritto alla proprietà privata assoluta", "Diritto alla cittadinanza automatica" ], "url_immagine": "" }, { "domanda": "Qual è la differenza principale tra una legge ordinaria e una legge costituzionale?", "risposte": [ "Le leggi costituzionali sono approvate dal Presidente della Repubblica", "Le leggi ordinarie regolano questioni meno importanti", "Le leggi costituzionali possono modificare la Costituzione", "Le leggi ordinarie sono temporanee" ], "url_immagine": "" }, { "domanda": "Quale tra i seguenti soggetti può proporre una legge in Italia?", "risposte": [ "Solo il Presidente della Repubblica", "Solo il Presidente del Consiglio", "I membri del Parlamento, il Governo, e in alcuni casi, i cittadini", "Solo i giudici costituzionali" ], "url_immagine": "" } ], "titolo": "Questionario di Valutazione delle Conoscenze Giuridiche" }, { "id_questionario": "26c17223-d40c-4876-9963-4e18e64ff351", "nome_autore": "frankrossi", "data_ora": "giovedì 27 giugno 2024, 23:53", "titolo": "Questionario di Valutazione delle Conoscenze Mediche", "descrizione": "Questo questionario ha lo scopo di valutare le tue conoscenze in ambito medico. Le domande coprono vari aspetti della medicina, dalla terminologia medica alle procedure cliniche. Per ogni domanda, seleziona la risposta che ritieni corretta tra le opzioni fornite.", "domande": [ { "domanda": "Qual è il termine medico per l'infiammazione delle articolazioni", "risposte": [ "Osteoporosi", "Artrite", "Bursite", "Tendinopatia" ], "url_immagine": "" }, { "domanda": "Quale tra le seguenti è una vitamina liposolubile", "risposte": [ "Vitamina C", "Vitamina B12", "Vitamina D", "Vitamina B6" ], "url_immagine": "" }, { "domanda": "Qual è la funzione principale dei globuli rossi nel sangue?", "risposte": [ "Combattere le infezioni", "Trasportare ossigeno", "Coagulare il sangue", "Rimuovere le tossine" ], "url_immagine": "" }, { "domanda": "Quale delle seguenti opzioni descrive meglio il concetto di 'anestesia generale'?", "risposte": [ "Perdita di sensazione limitata a una parte del corpo", "Sedazione lieve senza perdita di coscienza", "Perdita totale di coscienza e sensibilità", "Uso di farmaci per ridurre l'infiammazione" ], "url_immagine": "" }, { "domanda": "Cos'è l'ipertensione arteriosa?", "risposte": [ "Una condizione in cui il livello di zucchero nel sangue è basso", "Un aumento persistente della pressione del sangue nelle arterie", "Un'infezione delle vie urinarie", "Una carenza di globuli bianchi" ], "url_immagine": "" }, { "domanda": "Osserva l'immagine seguente e indica quale parte del corpo è rappresentata:", "risposte": [ "Addome", "Cranio", "Torace", "Pelvi" ], "url_immagine": "s3://immaginiquestionario/1719522303087_Domanda 6.jpg" } ], "titolo": "Questionario di Valutazione delle Conoscenze Mediche" }]''';

      List<Questionario> lista2 = List<Questionario>.from(json.decode(lista).map((i) => Questionario.fromJson(i)).toList());
      print(lista2);
      return lista2;
    } catch (e) {
      throw Exception('Caricamento fallito'+e.toString());
    }
  }
  Future<http.Response> salvaCompilazione(Map<String, dynamic> compilazioneCompleta) async {
    Uri uri = Uri.parse(Constants.ADDRESS_ECOMMERCE_SERVER+""+Constants.RICHIESTA_SALVA_COMPILAZIONE);
    print(compilazioneCompleta.toString());
    compilazioneCompleta.update("nome_utente", (value) => utente);

    try {
      var response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + _userAccessToken!,
        },
        body: jsonEncode(compilazioneCompleta),
      );

      return response;
    } catch (e) {
      throw Exception('Caricamento fallito');
    }
  }
  Future<http.Response> ottieniCompilazioni(String nome_utente) async {
    Uri uri = Uri.parse(Constants.ADDRESS_ECOMMERCE_SERVER+""+Constants.RICHIESTA_RICERCA_COMPILAZIONE+"?nome_utente="+nome_utente);


    try {
      var response = await http.get(
        uri,
        headers: <String, String>{
          'Authorization': 'Bearer ' + _userAccessToken!,
        },
      );
      print(response.body);
      return response;
    } catch (e) {
      throw Exception('Caricamento fallito');
    }
  }

  //GESTIONE INOLTRO EMAIL
  Future<http.Response> inoltroEmail(List<String> emailUtenti, String oggetto, String corpo) async {
    Uri uri = Uri.parse(Constants.ADDRESS_ECOMMERCE_SERVER +""+Constants.RICHIESTA_INVIO_EMAIL_TUTTI);
    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Authorization': 'Bearer ' + _userAccessToken!,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: <String, String>{
          'toEmail': emailUtenti.join(','),
          'oggetto': oggetto,
          'corpo': corpo,
        },
      );
      print(response.body);
      return response;
    } catch (e) {
      throw Exception('Registrazione fallita');
    }
  }

  //GESTIONE IMMAGINI
  Future<http.Response> caricaImmagine(Uint8List? _imageBytes, int indice) async {
    Uri uri = Uri.parse(Constants.ADDRESS_ECOMMERCE_SERVER+""+Constants.RICHIESTA_CARICA_IMMAGINI);
    var request = http.MultipartRequest('POST', uri, );
    request.headers['Authorization'] = 'Bearer ' + _userAccessToken!;

    // Aggiungi l'immagine come MultipartFile
    var multipartFile = http.MultipartFile.fromBytes(
      'file',
      _imageBytes!,
      filename: 'Domanda ${indice}.jpg', // Sostituisci con il nome appropriato del file
      contentType: MediaType('image', 'jpeg'), // Sostituisci con il tipo di contenuto appropriato
    );
    request.files.add(multipartFile);


    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        // Gestisci qui la risposta dal server se necessario
        return response;
      } else {
        print('Errore durante il caricamento del file: ${response.reasonPhrase}');
        return response;
      }
    } catch (e) {
      print('Eccezione durante il caricamento del file: $e');
      throw Exception('Caricamento fallito');
    }
  }
  Future<http.Response> eliminaImmagine(String fileName) async {
    Uri uri = Uri.parse(Constants.ADDRESS_ECOMMERCE_SERVER+""+Constants.RICHIESTA_ELIMINA_IMMAGINI+"?file_name="+fileName);

    final response = await http.get(uri,
      headers: <String, String>{
        'Authorization': 'bearer '+_userAccessToken!,
      },
    );

    try {
      if (response.statusCode == 200) {
        // Gestisci qui la risposta dal server se necessario
        print(response.body);
        return response;
      } else {
        print('Errore durante il caricamento del file: ${response.reasonPhrase}');
        return response;
      }
    } catch (e) {
      print('Eccezione durante il caricamento del file: $e');
      throw Exception('Caricamento fallito');
    }
  }
  Future<http.Response> scaricaImmagine(String urlImmagine) async {
    Uri uri = Uri.parse(Constants.ADDRESS_ECOMMERCE_SERVER+""+Constants.RICHIESTA_DOWNLOADNOME_IMMAGINI+"?file_name="+urlImmagine);
    print(uri);
    final response = await http.get(uri,
      headers: <String, String>{
        'Authorization': 'bearer '+_userAccessToken!,
      },
    );

    try {
      if (response.statusCode == 200) {
        // Gestisci qui la risposta dal server se necessarioì
        return response;
      } else {
        print('Errore durante il caricamento del file'); //: ${response.bodyBytes}');
        return response;
      }
    } catch (e) {
      print('Eccezione durante il caricamento del file: $e');
      throw Exception('Caricamento fallito');
    }
  }
  Future<Uint8List> scaricaImmagine2(String link) async {
    // Esegui la richiesta GET all'endpoint per ottenere l'URL dell'immagine
    Uri uri = Uri.parse(Constants.ADDRESS_ECOMMERCE_SERVER+""+Constants.RICHIESTA_DOWNLOADNOME_IMMAGINI+"?file_name="+link);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      // Presumi che il server ritorni l'URL dell'immagine come una stringa
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image');
    }
  }

  // LOGIN E REGISTRAZIONE
  Future<LogInResult> accessoUtente(String username, String password) async {
    Uri uri = Uri.parse(Constants.ADDRESS_ECOMMERCE_SERVER+""+Constants.RICHIESTA_LOGIN_UTENTE);

    try {
      final response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, String>{
            'email': username,
            'password': password,
          }),
      );

      _authenticationData = Autenticazione.fromJson(jsonDecode(response.body));
      _userAccessToken = _authenticationData!.getAccessToken();
      utente = username;
      print(_userAccessToken.toString());
      print(utente);
      return LogInResult.logged;
    } catch (e) {
      return LogInResult.error_unknown;
    }
  }
  Future<http.Response> registrazioneUtente(String username, String email, String password) async {
    Uri uri = Uri.parse(Constants.ADDRESS_ECOMMERCE_SERVER+""+Constants.RICHIESTA_REGISTRAZIONE_UTENTE);

    try {
      final response = await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },

        body: <String, String>{
          'username': username,
          'email': email,
          'password': password,
        },
      );
      return response;
    } catch (e) {
      throw Exception('Registrazione fallita');
    }
  }
  Future<http.Response> tuttiGliUtenti() async {
    Uri uri = Uri.parse(Constants.ADDRESS_ECOMMERCE_SERVER+""+Constants.RICHIESTA_TUTTI_UTENTI);

    try {
      final response = await http.get(uri,
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'bearer '+_userAccessToken!,
        },

      );
      print(response.body);
      return response;
    } catch (e) {
      throw Exception('Registrazione fallita');
    }
  }
  bool logout() {
    if(utente.isNotEmpty){
      utente = "";
      _userAccessToken = "";
      return true;
    }
    return false;
  }

  //GESTION RISULTATI
  Future<List<Risultati>> visualizzaRisultatiTuttti() async {
    Uri uri = Uri.parse(Constants.ADDRESS_ECOMMERCE_SERVER+""+Constants.RICHIESTA_RISULTATI_UTENTI);
    try {
      var response = await http.get(
        uri,
        // headers: <String, String>{
        //   'Authorization': 'Bearer ' + _userAccessToken!,
        // },
      );
      String lista = response.body;
      //String lista = '''[{"id_risultato":"59935831-baff-4c15-853e-3cd53f336075","nome_autore":"giusy","data_ora":"venerdì 28 giugno 2024, 17:52","titolo":"hhh","descrizione":"ccc","numeroRisposte":1,"resocontoDomande":[{"domanda":"fgjhdfgj","numeroRisposta":[{"risposta":"ghh","numero":3},{"risposta":"g","numero":1},{"risposta":"ghhjgc","numero":1},{"risposta":"jukiulk","numero":2}],"url_immagine":"NO"},{"domanda":"fghdhdg","numeroRisposta":[{"risposta":"hgjdcxsgth","numero":3},{"risposta":"xxxxxvc","numero":1}],"url_immagine":"NO"}]}]''';

      List<Risultati> lista2 = List<Risultati>.from(json.decode(lista).map((i) => Risultati.fromJson(i)).toList());

      print(lista2);
      return lista2;
    } catch (e) {
      throw Exception('Caricamento fallito'+e.toString());
    }
  }

// Future<bool> _refreshToken() async {
//   try {
//     Map<String, String> params = Map();
//     params["grant_type"] = "refresh_token";
//     params["client_id"] = Constants.CLIENT_ID;
//     params["client_secret"] = Constants.CLIENT_SECRET;
//     params["refresh_token"] = _authenticationData!.refreshToken;
//     String result = await _restManager.makePostRequest(Constants.ADDRESS_AUTHENTICATION_SERVER, Constants.REQUEST_LOGIN, params, type: TypeHeader.urlencoded);
//     _authenticationData = Autenticazione.fromJson(jsonDecode(result));
//     if ( _authenticationData!.hasError() ) {
//       return false;
//     }
//     _restManager.token = _authenticationData!.accessToken;
//     return true;
//   }
//   catch (e) {
//     return false;
//   }
// }

// Future<LogInResult> accessoUtente2(String username, String password) async {
//   try{
//     Map<String, String> params = Map();
//     params["email"] = username;
//     params["password"] = password;
//     String result = await _restManager.makePostRequest(Constants.ADDRESS_ECOMMERCE_SERVER, Constants.RICHIESTA_LOGIN_UTENTE, params, type: TypeHeader.json);
//     _authenticationData = Autenticazione.fromJson(jsonDecode(result));
//
//     print(_authenticationData);
//
//     print(_authenticationData!.accessToken);
//     _restManager.token = _authenticationData!.accessToken;
//     // Timer.periodic(Duration(seconds: (600)), (Timer t) { //600 secondi devono passare per il rinnovo
//     //     _refreshToken();
//     // });
//     return LogInResult.logged;
//   } catch (e) {
//     return LogInResult.error_unknown;
//   }
// }
}