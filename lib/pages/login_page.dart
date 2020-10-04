import 'dart:async';
import 'dart:io';
import 'package:verzel/helper/alerta.dart';
import 'package:verzel/helper/app_text.dart';
import 'package:verzel/helper/db_helper.dart';
import 'package:verzel/helper/nav.dart';
import 'package:verzel/helper/prefs.dart';
import 'package:flutter/material.dart';
import 'package:verzel/pages/cadastro_page.dart';
import 'package:verzel/pages/tarefa_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

//  final _streamController = StreamController<Usuario>();
//  final _bloc = LoginApi();
//  Tarefa tarefas;
  final _tEmail = TextEditingController();
  final _tSenha = TextEditingController();
  final _focusSenha = FocusNode();
  final db = DatabaseHelper.getInstance().db;

  @override
  void initState() {
    super.initState();
    //  Future db  = DatabaseHelper.getInstance().db;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'Tarefas',
          style: TextStyle(
            fontFamily: 'Aroma',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
            decoration: TextDecoration.none,
          ),
        ),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _onClickLogout,
          ),
        ],
      ),
      body: _body(),
    );
  }

  _body() {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(8),
        child: ListView(
          children: <Widget>[
            Divider(),
            Image.asset(
              "assets/verzel.png",
              height: 80,
            ),
            Divider(),
            SizedBox(height: 2),
            AppText(
              "E-mail",
              "Digite o email",
              controller: _tEmail,
              validator: (s) => _validateUsuario(s),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              nextFocus: _focusSenha,
            ),
            SizedBox(height: 2),
            AppText(
              "Senha",
              "Digite a senha",
              maxlen: 10,
              password: true,
              controller: _tSenha,
              validator: _validateSenha,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              nextFocus: _focusSenha,
            ),
            Divider(),
            SizedBox(
              height: 8,
            ),
            new FlatButton(
                child: new Text("Login"),
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: _onClickLogin),
            Divider(),
            Container(
                child: Row(
              children: <Widget>[
                Text('Não tem cadastro ?'),
                FlatButton(
                  textColor: Colors.blue,
                  child: Text(
                    'Cadastre aqui',
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: _onClickCadastrar,
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ))
          ],
        ),
      ),
    );
  }

  void _onClickCadastrar() async {
    push(context, HomeCadastro(), replace: false);
  }

  void _onClickLogin() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    String email = _tEmail.text;
    String senha = _tSenha.text;
    var dbClient = await db;
    var results = await dbClient.query("usuario",
        where: 'email = ? and senha = ?', whereArgs: [email, senha]);
    if (results.length > 0) {
      Prefs.setString('id', results[0]['id'].toString());
      Prefs.setString('nome', results[0]['nome'].toString());
      Prefs.setString('email', results[0]['email'].toString());
      push(context, TarefaPage(), replace: false);
    } else {
      Alerta(context, "Usuário ou senha inválida");
    }
  }

  String _validateUsuario(String text) {
    if (text.isEmpty) {
      return "Digite o usuário";
    }
    text.toUpperCase();
    return null;
  }

  String _validateSenha(String text) {
    if (text.isEmpty) {
      return "Digite a senha";
    }
    if (text.length < 3) {
      return "A senha precisa ter pelo menos 3 dígitos";
    }
    text.toUpperCase();
    return null;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onClickLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Atenção"),
          content: new Text("Deseja realmente sair ?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Sim"),
              onPressed: () {
                _onClickSair();
              },
            ),
            new FlatButton(
              child: new Text("Não"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onClickSair() async {
    Prefs.setString('id', "");
    Prefs.setString('nome', "");
    Prefs.setString('email', "");
    Future futureA = Future.delayed(Duration(seconds: 2));
    Future.wait([futureA]).then((List values) {
      exit(0);
    });
  }
}
