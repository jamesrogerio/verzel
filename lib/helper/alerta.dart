import 'package:flutter/material.dart';

void Alerta(context, msg) {
//  var d = response.data[0]["descr"];
  var d = msg;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text("Atenção"),
        content: new Text("$d"),
        actions: <Widget>[
          new FlatButton(
            child: new Text("Fechar"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
