import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/services.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:verzel/classes/datehelper.dart';
import 'package:verzel/classes/usuario.dart';
import 'package:verzel/helper/alerta.dart';
import 'package:verzel/helper/db_helper.dart';
import 'package:cep/cep.dart';

class HomeCadastro extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HomeCadastro();
}

class _HomeCadastro extends State<HomeCadastro> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final tNome = TextEditingController();
  final tEmail = TextEditingController();
  final tNascimento = TextEditingController();
  final tCpf = TextEditingController();
  final tCep = TextEditingController();
  final tBairro = TextEditingController();
  final tCidade = TextEditingController();
  final tEstado = TextEditingController();
  final tEndereco = TextEditingController();
  final tComplemento = TextEditingController();
  final tNumero = TextEditingController();
  final tSenha = TextEditingController();
  var db = DatabaseHelper.getInstance().db;
  var _showProgress = false;

  // Add validate email function.
  String _validateCPF(String value) {
    if (!CPFValidator.isValid(value)) {
      return 'CPF inválido.';
    }
    return null;
  }

  String _validateNascimento(String value) {
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
    DateTime data = DateTime.parse(dt);
//    DateTime now = new DateTime.now();
    Duration dur = DateTime.now().difference(data);
    String differenceInYears = (dur.inDays / 365).floor().toString();
    var anos = int.parse(differenceInYears);
    if (anos < 12) {
      Alerta(context, "Atenção: " + "Idade mínima para cadastro: 12 anos");
      return 'Data inválida';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          "Novo Usuário",
        ),
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
            controller: tNome,
            validator: _validateUsuario,
            maxLength: 50,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.black, fontSize: 16),
            decoration: new InputDecoration(
              hintText: '',
              labelText: 'Nome',
              labelStyle: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          new TextFormField(
            controller: tEmail,
            validator: _validateEmail,
            maxLength: 255,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            decoration: new InputDecoration(
              hintText: '',
              labelText: 'Email',
              labelStyle: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          new TextFormField(
            controller: tNascimento,
            maxLength: 10,
            keyboardType: TextInputType.number,
            validator: _validateNascimento,
            onChanged: (text) {
              if (text.length == 10) {
                _validateNascimento(text);
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
              labelText: 'Data de Nascimento',
              labelStyle: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          new TextFormField(
            controller: tCpf,
            keyboardType: TextInputType.number,
            validator: _validateCPF,
            inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly,
              CpfInputFormatter(),
            ],
            style: TextStyle(
              color: Colors.black,
              decorationColor: Colors.black,
              fontSize: 16,
            ),
            decoration: new InputDecoration(
              hintText: '',
              labelText: 'CPF',
              labelStyle: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          new TextFormField(
            controller: tCep,
            validator: _validateCep,
            maxLength: 8,
            keyboardType: TextInputType.text,
            onChanged: (text) {
              if (text.length == 8) {
                _validateCep1(text);
              }
            },
            style: TextStyle(
              color: Colors.black,
              decorationColor: Colors.black,
              fontSize: 16,
            ),
            decoration: new InputDecoration(
              hintText: '',
              labelText: 'CEP',
              labelStyle: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          new TextFormField(
            controller: tBairro,
            maxLength: 80,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.black,
              decorationColor: Colors.black,
              fontSize: 16,
            ),
            decoration: new InputDecoration(
              hintText: '',
              labelText: 'Bairro',
              labelStyle: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          new TextFormField(
            controller: tCidade,
            maxLength: 80,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.black,
              decorationColor: Colors.black,
              fontSize: 16,
            ),
            decoration: new InputDecoration(
              hintText: '',
              labelText: 'Cidade',
              labelStyle: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          new TextFormField(
            controller: tEstado,
            maxLength: 2,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.black,
              decorationColor: Colors.black,
              fontSize: 16,
            ),
            decoration: new InputDecoration(
              hintText: '',
              labelText: 'Estado',
              labelStyle: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          new TextFormField(
            controller: tEndereco,
            maxLength: 255,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.black,
              decorationColor: Colors.black,
              fontSize: 16,
            ),
            decoration: new InputDecoration(
              hintText: '',
              labelText: 'Endereço',
              labelStyle: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          new TextFormField(
            controller: tComplemento,
            maxLength: 100,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.black,
              decorationColor: Colors.black,
              fontSize: 16,
            ),
            decoration: new InputDecoration(
              hintText: '',
              labelText: 'Complemento',
              labelStyle: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          new TextFormField(
            controller: tNumero,
            maxLength: 10,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.black,
              decorationColor: Colors.black,
              fontSize: 16,
            ),
            decoration: new InputDecoration(
              hintText: '',
              labelText: 'Número',
              labelStyle: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          new TextFormField(
            controller: tSenha,
            maxLength: 255,
            obscureText: true,
            validator: _validateSenha,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.black,
              decorationColor: Colors.black,
              fontSize: 16,
            ),
            decoration: new InputDecoration(
              hintText: '',
              labelText: 'Senha',
              labelStyle: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          new Container(
            height: 40,
            margin: new EdgeInsets.only(top: 20.0),
            child: RaisedButton(
              color: Colors.blue,
//              color: Colors.blue,
              child: _showProgress
                  ? CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.white),
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
          )
        ],
      ),
    );
  }

  String _validateEmail(String text) {
    bool emailValid = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
        .hasMatch(text);
    if (emailValid == false) {
      return "email inválido";
    } else {
      return null;
    }
  }

  String _validateUsuario(String text) {
    if (text.isEmpty) {
      return "Digite o nome";
    }
    if (text == null) {
      return "Digite o nome";
    }
    if (text.length < 5) {
      return "O nome precisa ter pelo menos 5 dígitos";
    }
    return null;
  }

  String _validateSenha(String text) {
    if (text.isEmpty) {
      return "Digite a senha";
    }
    if (text.length < 3) {
      return "A senha precisa ter pelo menos 3 dígitos";
    }
    return null;
  }

  String _validateCep(String text) {
    if (text.isEmpty) {
      return null;
//      return "CEP inválido empty";
    }
    if (text.length < 8) {
      return "CEP inválido length";
    }
    _validateCep1(text);
  }

  _validateCep1(String text) async {
    if (text.length < 8) {
      return "CEP incompleto";
    }
    var resultado = await Cep.consultarCep(text);
    tBairro.text = resultado.bairro;
    tCidade.text = resultado.cidade;
    tEstado.text = resultado.uf;
    tEndereco.text = resultado.logradouro;
    tComplemento.text = resultado.complemento;
    if (resultado.cidade == null) {
      Alerta(context, "Atenção: " + "CEP não localizado");
      return "CEP não localizado";
    }
    return null;
  }

  _onClickSalvar(context) async {
    if (!_formKey.currentState.validate()) {
      return 'Dados inválidos';
    }
    var r = _validateUsuario(tNome.text);
    if (r != null) {
      Alerta(context, "Nome inválido");
      return "Nome inválido";
    }
    r = _validateEmail(tEmail.text);
    if (r != null) {
      Alerta(context, "Email inválido");
      return "Email inválido";
    }
    r = _validateNascimento(tNascimento.text);
    if (r != null) {
      Alerta(context, "Data de nascimento inválida");
      return "Data de nascimento inválida";
    }
    if (tCpf.text != "") {
      r = _validateCPF(tCpf.text);
      if (r != null) {
        Alerta(context, "CPF inválido");
        return "CPF inválido";
      }
    }
    r = _validateSenha(tSenha.text);
    if (r != null) {
      Alerta(context, "Senha inválida");
      return "Senha inválida";
    }
    await _onSave(context);
  }

  _onSave(BuildContext context) async {
    try {
      Usuario usuario = Usuario(
          tNome.text,
          tEmail.text,
          tNascimento.text,
          tCpf.text,
          tCep.text,
          tBairro.text,
          tCidade.text,
          tEstado.text,
          tEndereco.text,
          tComplemento.text,
          tNumero.text,
          tSenha.text);
      var dbClient = await db;
      var result = await dbClient.insert("usuario", usuario.toMap());
      Alerta(context, "Dados gravados com sucesso");
      return result;
    } catch (error) {
      Alerta(context, "Erro: " + error);
    }
  }
}
