import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interport_app/app/shared/model/Comunicados.dart';
import 'package:interport_app/app/shared/nav_bar.dart';
import 'comunicados_controller.dart';

class ComunicadosPage extends StatefulWidget {
  final String title;
  const ComunicadosPage({Key key, this.title = "Comunicados"})
      : super(key: key);

  @override
  _ComunicadosPageState createState() => _ComunicadosPageState();
}

class _ComunicadosPageState
    extends ModularState<ComunicadosPage, ComunicadosController> {
  //use 'controller' variable to access controller

  var condominioSelecionado;
  TextEditingController _controllerTitle = TextEditingController();
  TextEditingController _controllerContent = TextEditingController();
  String _title;
  String _content;
  String _condomino;
  Timestamp _data;
  Comunicado _comunicado;

  _cadastrarComunicado() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("Comunicados").doc(_comunicado.id).set(_comunicado.toMap());
  }

  @override
  void initState() {
    _comunicado = Comunicado.gerarID();
    super.initState();

    Widget _body() {
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
                  "Comunicados",
                  style: GoogleFonts.inter(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 30,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Condominios")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      Text("Carregando...");
                    } else {
                      List<DropdownMenuItem> condominiosItens = [];

                      for (int i = 0; i < snapshot.data.docs.length; i++) {
                        DocumentSnapshot snap = snapshot.data.docs[i];
                        condominiosItens.add(DropdownMenuItem(
                          child: Text(
                            snap.get("nome"),
                          ),
                          value: "${snap.get("nome")}",
                        ));
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          DropdownButton(
                            items: condominiosItens,
                            onChanged: (condominiosValue) {
                              setState(() {
                                condominioSelecionado = condominiosValue;
                                _comunicado.condominio = condominioSelecionado;
                              });
                            },
                            value: condominioSelecionado,
                            hint: Text("Selecione o Condominio"),
                          ),
                        ],
                      );
                    }
                    return Container();
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _controllerTitle,
                  onChanged: (title) {
                    _comunicado.title = title;
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
                        Icons.title,
                        color: Color(0xFF1E1C3F),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6)),
                      hintText: "Digite o titulo do comunicado",
                      labelText: "Titulo"),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _controllerContent,
                  onChanged: (content) {
                    _comunicado.content = content;
                  },
                  validator: (valor) {
                    if (valor.isEmpty) {
                      return "Este campo é obrigatorio";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      prefixIcon: Icon(
                        Icons.content_copy,
                        color: Color(0xFF1E1C3F),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6)),
                      hintText: "Digite o conteudo do comunicado",
                      labelText: "Conteudo"),
                  maxLines: 5,
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                    child: Text(
                      "ENVIAR",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Color(0xFF1E1C3F),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    padding: EdgeInsets.only(
                        left: 32, right: 32, top: 16, bottom: 16),
                    onPressed: () {
                      setState(() {
                        Timestamp data = Timestamp.now();
                        _title = _controllerTitle.text;
                        _content = _controllerContent.text;
                        _condomino = condominioSelecionado;
                        _data = data;
                        _comunicado.data = _data;
                        _cadastrarComunicado();
                      });
                    })
              ],
            ),
          ));
    }
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
                child: Container(
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
                          "Comunicados",
                          style: GoogleFonts.inter(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: 80,
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("Condominios")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              Text("Carregando...");
                            } else {
                              List<DropdownMenuItem> condominiosItens = [];

                              for (int i = 0;
                                  i < snapshot.data.docs.length;
                                  i++) {
                                DocumentSnapshot snap = snapshot.data.docs[i];
                                condominiosItens.add(DropdownMenuItem(
                                  child: Text(
                                    snap.get("nome"),
                                  ),
                                  value: "${snap.get("nome")}",
                                ));
                              }
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  DropdownButton(
                                    items: condominiosItens,
                                    onChanged: (condominiosValue) {
                                      setState(() {
                                        condominioSelecionado =
                                            condominiosValue;
                                        _comunicado.condominio =
                                            condominioSelecionado;
                                      });
                                    },
                                    value: condominioSelecionado,
                                    hint: Text("Selecione o Condominio"),
                                  ),
                                ],
                              );
                            }
                            return Container();
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _controllerTitle,
                          onChanged: (title) {
                            _comunicado.title = title;
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
                                Icons.title,
                                color: Color(0xFF1E1C3F),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6)),
                              hintText: "Digite o titulo do comunicado",
                              labelText: "Titulo"),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _controllerContent,
                          onChanged: (content) {
                            _comunicado.content = content;
                          },
                          validator: (valor) {
                            if (valor.isEmpty) {
                              return "Este campo é obrigatorio";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(32, 16, 32, 16),
                              prefixIcon: Icon(
                                Icons.content_copy,
                                color: Color(0xFF1E1C3F),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6)),
                              hintText: "Digite o conteudo do comunicado",
                              labelText: "Conteudo"),
                          maxLines: 5,
                          minLines: 1,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        RaisedButton(
                            child: Text(
                              "ENVIAR",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            color: Color(0xFF1E1C3F),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                            padding: EdgeInsets.only(
                                left: 32, right: 32, top: 16, bottom: 16),
                            onPressed: () {
                              setState(() {
                                Timestamp data = Timestamp.now();
                                _title = _controllerTitle.text;
                                _content = _controllerContent.text;
                                _condomino = condominioSelecionado;
                                _data = data;
                                _comunicado.data = _data;
                                _cadastrarComunicado();
                              });
                            })
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
