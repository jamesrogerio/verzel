import 'package:verzel/helper/db_helper.dart';
import 'package:verzel/helper/nav.dart';
import 'package:verzel/helper/prefs.dart';
import 'package:verzel/pages/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:verzel/pages/tarefa_page.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
//  final _bloc = LoginBloc();
  String user;
  String pwd;

  @override
  void initState() {
    //inicializando o banco de dados
    Future futureA = DatabaseHelper.getInstance().db;
    Future futureB = Future.delayed(Duration(seconds: 2));
    Future id = Prefs.getString("id");
    Future nome = Prefs.getString("nome");
    Future email = Prefs.getString("email");
    Future.wait([futureA, futureB, id, nome, email]).then((List values) {
      values[3] = "";
      if (values[3] == "") {
        push(context, LoginPage(), replace: true);
      } else {
        push(context, TarefaPage(), replace: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/verzel.png",
              height: 150,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              'Tarefas',
              style: TextStyle(
                fontFamily: 'Aroma',
                fontWeight: FontWeight.normal,
                fontSize: 25,
                color: Colors.white,
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.end,
            ),
            SizedBox(height: 10),
            CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.white)),
          ]),
    );
  }
}
