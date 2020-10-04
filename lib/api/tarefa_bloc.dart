import 'dart:async';
import 'package:verzel/api/tarefa_api.dart';

class TarefaBloc {
  final _streamController = StreamController<List>();
  Stream<List> get streamTarefa => _streamController.stream;

  Future<List> loadTarefa() async {
    try {
      List tarefas = await TarefaApi.filtrar();
      _streamController.add(tarefas);
    } catch (e) {
      _streamController.addError(e);
    }
  }

  void dispose() {
    _streamController.close();
  }
}
