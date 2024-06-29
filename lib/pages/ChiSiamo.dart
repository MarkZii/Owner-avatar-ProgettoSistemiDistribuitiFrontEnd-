import 'package:flutter/material.dart';
//import '../../model/Model.dart';


class ChiSiamo extends StatelessWidget {

  ChiSiamo({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 1500,
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 1000,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('SFONDO.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 50), // Spazio tra l'immagine e il testo
                    Column(
                      children: [
                        Text(
                          "Benvenuti su questionari.it\n",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Semplicià, Condivisione, Chiarezza\n",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          "La vostra piattaforma per creare, gestire e analizzare questionari online.\n\nCon questionari.it, è facile creare questionari coinvolgenti e personalizzati per raccogliere feedback, condurre ricerche o sondare le opinioni del vostro pubblico. E' possibile creare domande personalizzabili a risposta multipla, con la possibilità di riferirsi a delle immagini. E' possibile inoltre notificare, in maniera molto semplice, la publicazione di un nuovo questionario così da invogliare le persone a rispondere. Una volta raccolti i dati, questionari.it offre strumenti di analisi per aiutare a comprendere meglio i risultati. Con questionari.it, è facile raccogliere feedback preziosi e prendere decisioni informate basate sui dati. Iscrivetevi oggi stesso per un account gratuito e iniziate a creare il vostro primo questionario!",
                          style: TextStyle(
                            fontSize: 21,
                            color: Colors.black,
                            // TextAlign will align the text within the Text widget.
                            // In this case, we want the text to be center-aligned.
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        ],
                  ),
                ],
            ),
          ),
        ),
      ),
    );
  }
}