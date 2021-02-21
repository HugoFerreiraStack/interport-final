import 'package:circular_check_box/circular_check_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interport_app/app/shared/model/Condominio.dart';
import 'package:interport_app/app/shared/nav_bar.dart';
import 'cad_condominios_controller.dart';
import 'package:cep/cep.dart';

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
  final _controllerCep = MaskedTextController(mask: '00000-000');
  TextEditingController _controllerBairro = TextEditingController();
  TextEditingController _controllerNumeroDeBlocos = TextEditingController();
  TextEditingController _controllerNumeroDeApts = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String nome;
  String cidade = "Cidade";
  String bairro = "Bairro";
  String rua = "Rua";
  String numeroDeBlocos;
  String numeroDeApts;
  Condominio _condominio;
  bool _isChurrasqueira = false;
  bool _isSalaoDeFestas = false;
  bool _isAcademia = false;
  bool _isQuadraDeTenis = false;
  bool _isQuadraFutsal = false;
  bool _isPiscina = false;
  bool _isSalaDeJogos = false;

  _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    print(user.email);
  }

  _cadastrarCondominio() {
    if (nome.isNotEmpty) {
      if (cidade != "Cidade") {
        Condominio condominio = Condominio();
        condominio.id = _condominio.id;
        condominio.nome = nome;
        condominio.cidade = cidade;
        condominio.bairro = bairro;
        condominio.rua = rua;
        condominio.qtdApts = numeroDeApts;
        condominio.qtdBlocos = numeroDeBlocos;
        condominio.academia = _isAcademia;
        condominio.churrasqueira = _isChurrasqueira;
        condominio.piscina = _isPiscina;
        condominio.quadraDeTenis = _isQuadraDeTenis;
        condominio.quadraFutsal = _isQuadraFutsal;
        condominio.salaDeJogos = _isSalaDeJogos;
        condominio.salaoDeFestas = _isSalaoDeFestas;
        FirebaseFirestore db = FirebaseFirestore.instance;

        db
            .collection("Condominios")
            .doc(_condominio.id)
            .set(condominio.toMap())
            .catchError((err) => print('$err'));
        setState(() {
          cidade = "Cidade";
          bairro = "Bairro";
          rua = "Rua";
          _condominio = Condominio.gerarID();
        });
        _controllerNome.clear();
        _controllerCep.clear();
        _controllerNumeroDeApts.clear();
        _controllerNumeroDeBlocos.clear();
      }
    }
  }

  @override
  void initState() {
    _verificarUsuarioLogado();
    _condominio = Condominio.gerarID();
    super.initState();
  }

  Widget _rigthSidePage() {
    return Container(
        width: MediaQuery.of(context).size.width / 2,
        height: MediaQuery.of(context).size.height / 1,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Cadastro de Condomínios",
                style: GoogleFonts.inter(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      onChanged: (name) {
                        nome = name;
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
                          hintText: "Nome do Condominio",
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6))),
                    ),
                  ),
                  SizedBox(width: 20),
                  Flexible(
                    child: TextFormField(
                      validator: (valor) {
                        if (valor.isEmpty) {
                          return "Este campo é obrigatorio";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      controller: _controllerCep,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.place,
                            color: Color(0xFF1E1C3F),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.search,
                              color: Color(0xFF1E1C3F),
                            ),
                            onPressed: () async {
                              var resultado =
                                  await Cep.consultarCep(_controllerCep.text);
                              print('Cidade ${resultado.cidade}');
                              setState(() {
                                cidade = resultado.cidade;
                                bairro = resultado.bairro;
                                rua = resultado.logradouro;
                                print(rua);
                              });
                            },
                          ),
                          hintText: "Digite o CEP do Condominio",
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6))),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.place,
                            color: Color(0xFF1E1C3F),
                          ),
                          hintText: cidade,
                          contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6))),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                      child: TextFormField(
                    readOnly: true,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.place,
                          color: Color(0xFF1E1C3F),
                        ),
                        hintText: bairro,
                        contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6))),
                  )),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Flexible(
                      child: TextFormField(
                    readOnly: true,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.place,
                          color: Color(0xFF1E1C3F),
                        ),
                        hintText: rua,
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6))),
                  )),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      onChanged: (numBlc) {
                        numeroDeBlocos = numBlc;
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
                          hintText: "Nº de Blocos",
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6))),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: TextFormField(
                      onChanged: (numApts) {
                        numeroDeApts = numApts;
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
                          hintText: "Nº de Apartamentos",
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6))),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text("Areas de Lazer"),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: ListTile(
                      leading: CircularCheckBox(
                          value: _isChurrasqueira,
                          checkColor: Colors.white,
                          activeColor: Colors.green,
                          inactiveColor: Colors.redAccent,
                          disabledColor: Colors.grey,
                          onChanged: (val) => setState(() {
                                _isChurrasqueira = !_isChurrasqueira;
                              })),
                      title: Text("Churrasqueira?"),
                      onTap: () => setState(() {
                        _isChurrasqueira = !_isChurrasqueira;
                      }),
                    ),
                  ),
                  Flexible(
                    child: ListTile(
                      leading: CircularCheckBox(
                          value: _isAcademia,
                          checkColor: Colors.white,
                          activeColor: Colors.green,
                          inactiveColor: Colors.redAccent,
                          disabledColor: Colors.grey,
                          onChanged: (val) => setState(() {
                                _isAcademia = !_isAcademia;
                              })),
                      title: Text("Academia?"),
                      onTap: () => setState(() {
                        _isAcademia = !_isAcademia;
                        print(_isAcademia);
                      }),
                    ),
                  ),
                  Flexible(
                    child: ListTile(
                      leading: CircularCheckBox(
                          value: _isPiscina,
                          checkColor: Colors.white,
                          activeColor: Colors.green,
                          inactiveColor: Colors.redAccent,
                          disabledColor: Colors.grey,
                          onChanged: (val) => setState(() {
                                _isPiscina = !_isPiscina;
                              })),
                      title: Text("Piscina?"),
                      onTap: () => setState(() {
                        _isPiscina = !_isPiscina;
                      }),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: ListTile(
                      leading: CircularCheckBox(
                          value: _isQuadraDeTenis,
                          checkColor: Colors.white,
                          activeColor: Colors.green,
                          inactiveColor: Colors.redAccent,
                          disabledColor: Colors.grey,
                          onChanged: (val) => setState(() {
                                _isQuadraDeTenis = !_isQuadraDeTenis;
                              })),
                      title: Text("Quadra De Tenis?"),
                      onTap: () => setState(() {
                        _isQuadraDeTenis = !_isQuadraDeTenis;
                      }),
                    ),
                  ),
                  Flexible(
                    child: ListTile(
                      leading: CircularCheckBox(
                          value: _isQuadraFutsal,
                          checkColor: Colors.white,
                          activeColor: Colors.green,
                          inactiveColor: Colors.redAccent,
                          disabledColor: Colors.grey,
                          onChanged: (val) => setState(() {
                                _isQuadraFutsal = !_isQuadraFutsal;
                              })),
                      title: Text("Quadra Futsal?"),
                      onTap: () => setState(() {
                        _isQuadraFutsal = !_isQuadraFutsal;
                      }),
                    ),
                  ),
                  Flexible(
                    child: ListTile(
                      leading: CircularCheckBox(
                          value: _isSalaDeJogos,
                          checkColor: Colors.white,
                          activeColor: Colors.green,
                          inactiveColor: Colors.redAccent,
                          disabledColor: Colors.grey,
                          onChanged: (val) => setState(() {
                                _isSalaDeJogos = !_isSalaDeJogos;
                              })),
                      title: Text("Sala De Jogos?"),
                      onTap: () => setState(() {
                        _isSalaDeJogos = !_isSalaDeJogos;
                      }),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: ListTile(
                      leading: CircularCheckBox(
                          value: _isSalaoDeFestas,
                          checkColor: Colors.white,
                          activeColor: Colors.green,
                          inactiveColor: Colors.redAccent,
                          disabledColor: Colors.grey,
                          onChanged: (val) => setState(() {
                                _isSalaoDeFestas = !_isSalaoDeFestas;
                                print(_isSalaoDeFestas);
                              })),
                      title: Text("Salao De Festas?"),
                      onTap: () => setState(() {
                        _isSalaoDeFestas = !_isSalaoDeFestas;
                      }),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
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
                      numeroDeBlocos = _controllerNumeroDeBlocos.text;
                      numeroDeApts = _controllerNumeroDeApts.text;
                      formKey.currentState.save();
                      _cadastrarCondominio();
                    });
                  }
                },
              )
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFF1E1C3F), Colors.black]),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Navbar(),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 30.0, horizontal: 60.0),
                child: _rigthSidePage(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
