import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'login_controller.dart';

class LoginPage extends StatefulWidget {
  final String title;
  const LoginPage({Key key, this.title = "Login"}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ModularState<LoginPage, LoginController> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerSenha = TextEditingController();
  var tipoUsuarioSelecionado;

  String email, senha;
  String _mensagemErro = "";
  String tipoUsuarioLogado = "";
  List<String> _tipoUsuario = <String>[
    "Morador",
    "Sindico",
    "Admin",
    "Funcionario"
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _verificarUsuarioLogado();
    });
    super.initState();
  }

  _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    if (user != null) {
      await Modular.to.pushReplacementNamed("/cad_condominio");
    }
  }

  _validarCampos() async {
    email = _controllerEmail.text;
    senha = _controllerSenha.text;

    if (email.isNotEmpty && email.contains("@")) {
      if (senha.isNotEmpty && senha.length > 5) {
        _auth
            .signInWithEmailAndPassword(email: email, password: senha)
            .then((firebaseUser) async {
          await Modular.to.pushReplacementNamed("/admin");
          //_verificarUsuarioLogado(tipoUsuarioLogado);
          /*
          if (tipoUsuarioLogado == tipoUsuarioSelecionado) {
            if (tipoUsuarioLogado == "Morador") {
              Modular.to.pushReplacementNamed("/start");
            } else if (tipoUsuarioLogado == "Admin") {
              Modular.to.pushReplacementNamed("/admin");
            } else if (tipoUsuarioLogado == "Sindico") {
              Modular.to.pushReplacementNamed("start");
            }
          }*/
        }).catchError((onError) {
          setState(() {
            _mensagemErro = "Erro ao Fazer Login";
          });
        });
      } else {
        setState(() {
          _mensagemErro = "Sua senha deve ter no minimo 6 caracteres";
        });
      }
    } else {
      setState(() {
        _mensagemErro = "Preencha um E-mail Válido";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 3,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Image.asset(
                      "images/logo.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email,
                          color: Color(0xFF1E1C3F),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6)),
                        labelText: 'E-mail'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _controllerSenha,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    onChanged: (value) {
                      setState(() {
                        senha = value;
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Color(0xFF1E1C3F),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6)),
                      labelText: 'Senha',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  /*
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DropdownButton(
                        items: _tipoUsuario
                            .map((value) => DropdownMenuItem(
                                  child: Text(
                                    value,
                                  ),
                                  value: value,
                                ))
                            .toList(),
                        onChanged: (_tipoUsuarioSelecionado) {
                          setState(() {
                            tipoUsuarioSelecionado = _tipoUsuarioSelecionado;
                          });
                        },
                        value: tipoUsuarioSelecionado,
                        hint: Text("Selecione o Tipo de Usuario"),
                      )
                    ],
                  ),*/
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    color: Color(0xFF1E1C3F),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    padding: EdgeInsets.only(
                        left: 80, right: 80, top: 16, bottom: 16),
                    onPressed: () async {
                      await _validarCampos();
                    },
                    child: Text(
                      "CONTINUAR",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {},
                        child: Text(
                          "Esqueceu a Senha?",
                          style: TextStyle(color: Colors.cyan, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Text(_mensagemErro)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
