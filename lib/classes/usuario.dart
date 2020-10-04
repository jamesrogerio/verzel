class Usuario {
//  int id;
  String nome;
  String email;
  String dataNascimento;
  String cpf;
  String cep;
  String bairro;
  String cidade;
  String estado;
  String endereco;
  String complemento;
  String numero;
  String senha;

  Usuario(
      this.nome,
      this.email,
      this.dataNascimento,
      this.cpf,
      this.cep,
      this.bairro,
      this.cidade,
      this.estado,
      this.endereco,
      this.complemento,
      this.numero,
      this.senha);

  Usuario.fromJson(Map<String, dynamic> usuarioJson)
//      : id = usuarioJson['id'],
      : nome = usuarioJson['nome'],
        email = usuarioJson['email'],
        dataNascimento = usuarioJson['dataNascimento'],
        cpf = usuarioJson['cpf'],
        cep = usuarioJson['cep'],
        bairro = usuarioJson['bairro'],
        cidade = usuarioJson['cidade'],
        estado = usuarioJson['estado'],
        endereco = usuarioJson['endereco'],
        complemento = usuarioJson['complemento'],
        numero = usuarioJson['numero'],
        senha = usuarioJson['senha'];

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> dlogin = new Map<String, dynamic>();
//    dlogin['id'] = this.id;
    dlogin['nome'] = this.nome;
    dlogin['email'] = this.email;
    dlogin['dataNascimento'] = this.dataNascimento;
    dlogin['cpf'] = this.cpf;
    dlogin['cep'] = this.cep;
    dlogin['bairro'] = this.bairro;
    dlogin['cidade'] = this.cidade;
    dlogin['estado'] = this.estado;
    dlogin['endereco'] = this.endereco;
    dlogin['complemento'] = this.complemento;
    dlogin['numero'] = this.numero;
    dlogin['senha'] = this.senha;
    return dlogin;
  }
}
