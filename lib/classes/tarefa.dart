class Tarefa {
  int fkusuario;
  String descricao;
  String dataEntrega;
  String dataConclusao;

  Tarefa(this.fkusuario, this.descricao, this.dataEntrega, this.dataConclusao);

  Tarefa.fromJson(Map<String, dynamic> tarefaJson)
      : fkusuario = tarefaJson['fkusuario'],
        descricao = tarefaJson['descricao'],
        dataEntrega = tarefaJson['dataEntrega'],
        dataConclusao = tarefaJson['dataConclusao'];

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> tarefaMap = new Map<String, dynamic>();
    tarefaMap['fkusuario'] = this.fkusuario;
    tarefaMap['descricao'] = this.descricao;
    tarefaMap['dataEntrega'] = this.dataEntrega;
    tarefaMap['dataConclusao'] = this.dataConclusao;
    return tarefaMap;
  }
}
