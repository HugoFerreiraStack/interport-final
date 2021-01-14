import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:interport_app/app/shared/model/Condominio.dart';
import 'cad_condominios_controller.dart';

class CadCondominiosPage extends StatefulWidget {
  final String title;
  const CadCondominiosPage({Key key, this.title = "Cadastro de Condominios"})
      : super(key: key);

  @override
  _CadCondominiosPageState createState() => _CadCondominiosPageState();
}

class _CadCondominiosPageState
    extends ModularState<CadCondominiosPage, CadCondominiosController> {
  //use 'controller' variable to access controller

  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerCidade = TextEditingController();
  TextEditingController _controllerBairro = TextEditingController();
  TextEditingController _controllerNumeroDeBlocos = TextEditingController();
  TextEditingController _controllerNumeroDeApts = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String nome;
  String cidade;
  String bairro;
  String numeroDeBlocos;
  String numeroDeApts;
  Condominio _condominio;

  _cadastrarCondominio() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    db.collection("Condominios").doc(_condominio.id).set(_condominio.toMap());
  }

  @override
  void initState() {
    _condominio = Condominio.gerarID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1E1C3F),
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  onSaved: (nome) {
                    _condominio.nome = nome;
                    print(nome);
                  },
                  validator: (valor) {
                    if (valor.isEmpty) {
                      return "Este campo é obrigatorio";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.place,
                        color: Color(0xFF1E1C3F),
                      ),
                      hintText: "Digite o nome do Condominio",
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  onSaved: (cidade) {
                    _condominio.cidade = cidade;
                  },
                  validator: (valor) {
                    if (valor.isEmpty) {
                      return "Este campo é obrigatorio";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.place,
                        color: Color(0xFF1E1C3F),
                      ),
                      hintText: "Digite a cidade do Condominio",
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  onSaved: (bairro) {
                    _condominio.bairro = bairro;
                  },
                  validator: (valor) {
                    if (valor.isEmpty) {
                      return "Este campo é obrigatorio";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.place,
                        color: Color(0xFF1E1C3F),
                      ),
                      hintText: "Digite o bairro do Condominio",
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  onSaved: (numeroDeBlocos) {
                    _condominio.qtdBlocos = numeroDeBlocos;
                  },
                  validator: (valor) {
                    if (valor.isEmpty) {
                      return "Este campo é obrigatorio";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.place,
                        color: Color(0xFF1E1C3F),
                      ),
                      hintText: "Digite o Nº de Blocos",
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  onSaved: (numeroDeApts) {
                    _condominio.qtdApts = numeroDeApts;
                  },
                  validator: (valor) {
                    if (valor.isEmpty) {
                      return "Este campo é obrigatorio";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.place,
                        color: Color(0xFF1E1C3F),
                      ),
                      hintText: "Digite o Nº de Apartamentos",
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  child: Text(
                    "CADASTRAR",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  color: Color(0xFF1E1C3F),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  padding:
                      EdgeInsets.only(left: 80, right: 80, top: 16, bottom: 16),
                  onPressed: () async {
                    if (formKey.currentState.validate()) {
                      setState(() {
                        nome = _controllerNome.text;
                        cidade = _controllerCidade.text;
                        bairro = _controllerBairro.text;
                        numeroDeBlocos = _controllerNumeroDeBlocos.text;
                        numeroDeApts = _controllerNumeroDeApts.text;
                        formKey.currentState.save();
                        _cadastrarCondominio();
                        Modular.to.pop();
                      });
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
