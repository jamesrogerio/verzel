import 'package:verzel/api/tarefa_bloc.dart';
import 'package:verzel/classes/tarefa1.dart';
import 'package:verzel/helper/alerta.dart';
import 'package:verzel/helper/db_helper.dart';
import 'package:verzel/helper/nav.dart';
import 'package:verzel/helper/prefs.dart';
import 'package:verzel/pages/cadastro_lista_page.dart';
import 'package:verzel/pages/login_page.dart';
import 'package:flutter/material.dart';

class TarefaPage extends StatefulWidget {
  @override
  _HomeTarefaState createState() => _HomeTarefaState();
}

class _HomeTarefaState extends State<TarefaPage> {
  final _bloc = TarefaBloc();
  final db = DatabaseHelper.getInstance().db;

  @override
  void initState() {
    super.initState();
    _bloc.loadTarefa();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Tarefas"),
          centerTitle: true,
          backgroundColor: Colors.blue,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: _onClickLogout,
            ),
          ],
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => {push(context, LoginPage(), replace: false)}),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Prefs.setString('id_tarefa', "0");
              Prefs.setString('descricao', "");
              Prefs.setString('datae', "");
              Prefs.setString('datac', "");
              Prefs.setString('fkusuario', "");
              Prefs.setString('action', "INSERT");
              _onClickCadastrar();
            }),
        body: Container(
            padding: EdgeInsets.all(12),
            child: Container(
              padding: EdgeInsets.all(12),
              child: _body(context),
            )));
  }

  void _onClickCadastrar() async {
    push(context, HomeCadastroLista(), replace: false);
  }

  _body(BuildContext context) {
//    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: _bloc.streamTarefa,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Erro de conexão",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  fontSize: 24,
                ),
              ),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data.length == 0) {
            return Center(
              child: Text(
                "Não localizei tarefa",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  fontSize: 24,
                ),
              ),
            );
          } else if (snapshot.data == null) {
            return Center(
              child: Text(
                "Não localizei tarefa",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  fontSize: 24,
                ),
              ),
            );
          }
          return _retornoStream(context, snapshot);
        });
  }

  confirmDelete(BuildContext context, Tarefa1 t) async {
    var dbClient = await db;
    await dbClient.rawDelete('DELETE FROM tarefa WHERE id = ?', [t.id]);
    setState(() {
      _bloc.loadTarefa();
    });
    Navigator.of(context).pop();
  }

  showAlertDialog(BuildContext context, Tarefa1 t) async {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Não"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
        child: Text("Sim"),
        onPressed: () {
          confirmDelete(context, t);
        });
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Atenção"),
      content: Text('Confirma exclusão de tarefa: ' + t.descricao + ' ?'),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _retornoStream(context, snapshot) {
    return ListView.builder(
        itemCount: snapshot.data?.length,
        itemBuilder: (ctx, index) {
          Tarefa1 tarefa = snapshot.data[index];
          return Container(
            child: new Row(
              children: <Widget>[
                new Expanded(
                  flex: 9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[new Text(tarefa.descricao)],
                  ),
                ),
                new Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
//                        iconSize: 25,
                        icon: Icon(Icons.edit),
                        color: Colors.green,
                        onPressed: () {
                          Prefs.setString('id_tarefa', tarefa.id.toString());
                          Prefs.setString(
                              'descricao', tarefa.descricao.toString());
                          Prefs.setString(
                              'datae', tarefa.dataEntrega.toString());
                          Prefs.setString(
                              'datac', tarefa.dataConclusao.toString());
                          Prefs.setString(
                              'fkusuario', tarefa.fkusuario.toString());
                          Prefs.setString('action', "UPDATE");
                          _onClickCadastrar();
                        },
                      ),
                    ],
                  ),
                ),
                new Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.find_in_page),
                        color: Colors.orange,
                        onPressed: () {
                          final String d = "Tarefa: " + tarefa.descricao;
                          final String de =
                              "Data de Entrega: " + tarefa.dataEntrega;
                          final String dc =
                              "Daat de Conclusão: " + tarefa.dataConclusao;
                          final String t = d + '\n' + de + '\n' + dc;
                          Alerta(context, t);
                        },
                      ),
                    ],
                  ),
                ),
                new Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.refresh),
                        color: Colors.blue,
                        onPressed: () {
                          if (tarefa.dataConclusao != '') {
                            Alerta(context, 'Tarefa já concluída!!!');
                          } else {
                            Prefs.setString('id_tarefa', tarefa.id.toString());
                            Prefs.setString(
                                'descricao', tarefa.descricao.toString());
                            Prefs.setString(
                                'datae', tarefa.dataEntrega.toString());
                            Prefs.setString(
                                'datac', tarefa.dataConclusao.toString());
                            Prefs.setString(
                                'fkusuario', tarefa.fkusuario.toString());
                            Prefs.setString('action', "UPDATE");
                            _onClickCadastrar();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                new Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () {
                          showAlertDialog(context, tarefa);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  _onClickLogout() async {
    push(context, LoginPage(), replace: true);
  }
}
