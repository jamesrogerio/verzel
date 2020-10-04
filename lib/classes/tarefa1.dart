class Tarefa1 {
  int id;
  int fkusuario;
  String descricao;
  String dataEntrega;
  String dataConclusao;

  Tarefa1(this.id, this.fkusuario, this.descricao, this.dataEntrega,
      this.dataConclusao);

  Tarefa1.fromJson(Map<String, dynamic> tarefaJson)
      : id = tarefaJson['id'],
        fkusuario = tarefaJson['fkusuario'],
        descricao = tarefaJson['descricao'],
        dataEntrega = tarefaJson['dataEntrega'],
        dataConclusao = tarefaJson['dataConclusao'];

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> tarefaMap = new Map<String, dynamic>();
    tarefaMap['id'] = this.id;
    tarefaMap['fkusuario'] = this.fkusuario;
    tarefaMap['descricao'] = this.descricao;
    tarefaMap['dataEntrega'] = this.dataEntrega;
    tarefaMap['dataConclusao'] = this.dataConclusao;
    return tarefaMap;
  }
}
