import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/services.dart';
import 'package:verzel/classes/datehelper.dart';
import 'package:verzel/classes/tarefa.dart';
import 'package:verzel/classes/tarefa1.dart';
import 'package:verzel/helper/alerta.dart';
import 'package:verzel/helper/db_helper.dart';
import 'package:verzel/helper/prefs.dart';
import 'package:verzel/pages/tarefa_page.dart';
import 'package:verzel/helper/nav.dart';

class HomeCadastroLista extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HomeCadastroLista();
}

class _HomeCadastroLista extends State<HomeCadastroLista> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  var tUsuario = TextEditingController();
  var tDescricao = TextEditingController();
  var tEntrega = TextEditingController();
  var tConclusao = TextEditingController();
  var db = DatabaseHelper.getInstance().db;
  String action;
  var _showProgress = false;

  @override
  void initState() {
    super.initState();
    Future tid = Prefs.getString("id_tarefa");
    Future td = Prefs.getString("descricao");
    Future tde = Prefs.getString("datae");
    Future tdc = Prefs.getString("datac");
    Future tda = Prefs.getString('action');
    Future.wait([tid, td, tde, tdc, tda]).then((List values) {
      action = values[4];
      if (values[0] != "") {
        tDescricao.text = values[1];
        tEntrega.text = values[2];
        tConclusao.text = values[3];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          "Tarefas",
        ),
        leading: new IconButton(
            icon: new Icon(Icons.ac_unit),
            onPressed: () => {Alerta(context, "Clique no botão voltar")}),
        backgroundColor: Colors.blue,
      ),
      body: new Container(
        padding: new EdgeInsets.all(16),
        child: _form(),
      ),
    );
  }

  _form() {
    return new Form(
      key: this._formKey,
      child: new ListView(
        children: <Widget>[
          new TextFormField(
            controller: tDescricao,
            validator: _validateDescricao,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.black, fontSize: 16),
            decoration: new InputDecoration(
              hintText: '',
              labelText: 'Descrição Tarefa',
              labelStyle: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          new TextFormField(
            controller: tEntrega,
            maxLength: 10,
            keyboardType: TextInputType.number,
            validator: _validateEntrega,
            onChanged: (text) {
              if (text.length == 10) {
                _validateEntrega(text);
              }
            },
            inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly,
              DataInputFormatter(),
            ],
            style: TextStyle(
              color: Colors.black,
              decorationColor: Colors.black,
              fontSize: 16,
            ),
            decoration: new InputDecoration(
              hintText: 'DD/MM/YYYY',
              labelText: 'Data de Entrega',
              labelStyle: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          new TextFormField(
            controller: tConclusao,
            maxLength: 10,
            keyboardType: TextInputType.number,
            validator: _validateConclusao,
            onChanged: (text) {
              if (text.length == 10) {
                _validateConclusao(text);
              }
            },
            inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly,
              DataInputFormatter(),
            ],
            style: TextStyle(
              color: Colors.black,
              decorationColor: Colors.black,
              fontSize: 16,
            ),
            decoration: new InputDecoration(
              hintText: 'DD/MM/YYYY',
              labelText: 'Data de Conclusão',
              labelStyle: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          new Container(
            child: new Row(
              children: <Widget>[
                new Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      RaisedButton(
                        color: Colors.red,
                        child: _showProgress
                            ? CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              )
                            : new Text(
                                "Voltar",
                                style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                        onPressed: () {
                          push(context, TarefaPage(), replace: false);
                        },
                      ),
                    ],
                  ),
                ),
                new Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      RaisedButton(
                        color: Colors.blue,
                        child: _showProgress
                            ? CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              )
                            : new Text(
                                "Salvar",
                                style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                        onPressed: () {
                          _onClickSalvar(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _validateDescricao(String text) {
    if (text.isEmpty) {
      return "Digite descrição da tarefa";
    }
    if (text.length < 3) {
      return "A descrição da tarefa precisa ter pelo menos 3 dígitos";
    }
    text.toUpperCase();
    return null;
  }

  String _validateEntrega(String value) {
    if (value == '') {
//      Alerta(context, "Atenção: " + "Data inválida");
      return 'Data inválida';
    }
    String dia = value.substring(0, 2); // 'artlang'
    String mes = value.substring(3, 5); // 'artlang'
    String ano = value.substring(6, 10); // 'artlang'
    String dt = ano + '-' + mes + '-' + dia;
    bool d = DateHelper.isValidDateBirth(value, "DD/MM/YYYY");
    if (d == false) {
      Alerta(context, "Data inválida: " + "");
      return 'Data inválida';
    }
    return null;
  }

  String _validateConclusao(String value) {
    if (value == '') {
      return null;
    }
    String dia = value.substring(0, 2); // 'artlang'
    String mes = value.substring(3, 5); // 'artlang'
    String ano = value.substring(6, 10); // 'artlang'
    String dt = ano + '-' + mes + '-' + dia;
    bool d = DateHelper.isValidDateBirth(value, "DD/MM/YYYY");
    if (d == false) {
      Alerta(context, "Data inválida: " + "");
      return 'Data inválida';
    }
    return null;
  }

  _onClickSalvar(context) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    await _onSave(context);
  }

  _onSave(BuildContext context) async {
    try {
      String fkidd = await Prefs.getString("id");
      var fkid = int.parse(fkidd);
      String idd = await Prefs.getString("id_tarefa");
      var id = int.parse(idd);
      var dbClient = await db;
      if (action == "INSERT") {
        Tarefa tarefa =
            Tarefa(fkid, tDescricao.text, tEntrega.text, tConclusao.text);
        var resulti = await dbClient.insert("tarefa", tarefa.toMap());
        Alerta(context, "Dados gravados com sucesso");
        return resulti;
      } else {
        Tarefa1 tarefa =
            Tarefa1(id, fkid, tDescricao.text, tEntrega.text, tConclusao.text);
        var dbClient = await db;
        var resultu = await dbClient.update("tarefa", tarefa.toMap());
        Alerta(context, "Dados gravados com sucesso");
        return resultu;
      }
    } catch (error) {
      Alerta(context, "Erro: " + error);
    }
  }
}
