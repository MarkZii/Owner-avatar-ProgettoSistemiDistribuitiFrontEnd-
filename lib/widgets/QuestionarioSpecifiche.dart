import 'package:flutter/material.dart';
import 'package:frontendsistemidistribuitiprogetto/model/objects/Questionario.dart';


class QuestionarioSpecifiche extends StatelessWidget {
  final Questionario questionario;

  QuestionarioSpecifiche({required Key key, required this.questionario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 3.0,
        left: 30.0,
        right: 30.0,
        bottom: 3.0,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nome: "+questionario.id_questionario,
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),

                        Text(
                          "Cod. a barre: "+questionario.data_ora,
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Text(
                          "Quantità disponibile: "+questionario.nome_autore,
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Text(
                          "Categoria: "+questionario.titolo,
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Text(
                          "Categoria: "+questionario.domande.toString(),
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    // WidgetAcquisto(
                    //   key: UniqueKey(),
                    //   id: prodotto.id,
                    //   quantita: prodotto.quantita,
                    //   codiceBarre: prodotto.codiceBarre,
                    //   prezzo: prodotto.prezzo!,
                    // ),
                  ],
                ),
                Text(
                  "Descrizione: "+questionario.descrizione,
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}