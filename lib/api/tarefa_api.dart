import 'package:verzel/classes/tarefa1.dart';
import 'package:verzel/helper/prefs.dart';
import 'package:verzel/helper/db_helper.dart';

class TarefaApi {
  static Future<List> filtrar() async {
    try {
      var db = DatabaseHelper.getInstance().db;
      String id = await Prefs.getString("id");
      var dbClient = await db;
      var response = await dbClient
          .query("tarefa", where: 'fkusuario = ?', whereArgs: [id]);
      if (response.length > 0) {
        List tarefas =
            response.map<Tarefa1>((map) => Tarefa1.fromJson(map)).toList();
        return tarefas;
      } else {
        return response;
      }
    } catch (error) {
      print("ERRO API $error");
    }
  }
}
