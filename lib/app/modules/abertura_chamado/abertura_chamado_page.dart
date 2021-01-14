import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:interport_app/app/shared/model/chamados.dart';
import 'abertura_chamado_controller.dart';

class AberturaChamadoPage extends StatefulWidget {
  final String title;
  const AberturaChamadoPage({Key key, this.title = "AberturaChamado"})
      : super(key: key);

  @override
  _AberturaChamadoPageState createState() => _AberturaChamadoPageState();
}

class _AberturaChamadoPageState
    extends ModularState<AberturaChamadoPage, AberturaChamadoController> {
  //use 'controller' variable to access controller
  TextEditingController _controllerSubject = TextEditingController();
  TextEditingController _controllerContent = TextEditingController();
  String subject;
  String content;
  String condominium;
  Timestamp dateStart;
  Timestamp dateFinish;
  bool status;
  final formKey = GlobalKey<FormState>();
  var condominioSelecionado;
  Chamados _chamado;

  _abrirChamado() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    db.collection("Chamados").doc(_chamado.id).set(_chamado.toMap());
  }

  @override
  void initState() {
    _chamado = Chamados.generateID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1E1C3F),
        title: Text("Abertuda de Chamado"),
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
                                condominium = condominioSelecionado;
                                _chamado.condominium = condominium;
                              });
                            },
                            value: condominioSelecionado,
                            hint: Text("Selecione o Condominio"),
                          ),
                        ],
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  onSaved: (sub) {
                    _chamado.subject = sub;
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
                        Icons.chat,
                        color: Color(0xFF1E1C3F),
                      ),
                      hintText: "Assunto",
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onSaved: (description) {
                    _chamado.content = description;
                  },
                  validator: (valor) {
                    if (valor.isEmpty) {
                      return "Este campo é obrigatorio";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.chat,
                        color: Color(0xFF1E1C3F),
                      ),
                      hintText: "Descrição",
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
                    "ABRIR CHAMADO",
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
                        subject = _controllerSubject.text;
                        content = _controllerContent.text;
                        condominium = condominioSelecionado;
                        _chamado.condominium = condominium;
                        _chamado.dateStart = Timestamp.now();
                        _chamado.dateFinish = null;
                        _chamado.finish = false;
                        formKey.currentState.save();
                        _abrirChamado();
                        Modular.to.pop();
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
