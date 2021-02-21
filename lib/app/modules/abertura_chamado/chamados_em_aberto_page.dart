import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ChamadosEmAbertoPage extends StatefulWidget {
  @override
  _ChamadosEmAbertoPageState createState() => _ChamadosEmAbertoPageState();
}

class _ChamadosEmAbertoPageState extends State<ChamadosEmAbertoPage> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  dynamic docSelecionado;
  bool finish = false;
  DateFormat formatter = DateFormat('dd/MM/yyyy   hh:mm a');

  Future<Stream<QuerySnapshot>> _exibirChamados() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    Query query = db.collection("Chamados").where("finish", isEqualTo: false);

    Stream<QuerySnapshot> stream = query.snapshots();
    //print(_selected);

    stream.listen((dados) {
      dados.docs.forEach((element) {
        print(element.data());
      });
      _controller.add(dados);
    });
  }

  _updateData(selectedDoc, newValue) {
    FirebaseFirestore.instance
        .collection("Chamados")
        .doc(selectedDoc)
        .update(newValue)
        .catchError((e) {
      print(e);
    });
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () {
        Modular.to.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Confirmar"),
      onPressed: () {
        _updateData(docSelecionado, {"finish": true});
        _updateData(docSelecionado, {"dateFinish": Timestamp.now()});

        Modular.to.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Finalizar Chamado"),
      content: Text("Tem certeza que deseja finalizar esse chamado?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    _exibirChamados();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var carregandoDados = Center(
      child: Column(
        children: <Widget>[CircularProgressIndicator()],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1E1C3F),
        title: Text("Chamados em Aberto"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            StreamBuilder(
                stream: _controller.stream,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return carregandoDados;
                      break;
                    case ConnectionState.active:
                    case ConnectionState.done:
                      QuerySnapshot querySnapshot = snapshot.data;
                      if (querySnapshot.docs.length == 0) {
                        return Container(
                          padding: EdgeInsets.all(25),
                          child: Text(
                            "",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          padding: EdgeInsets.all(5),
                          itemBuilder: (context, i) {
                            return new Card(
                              shadowColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              color: Colors.grey[200],
                              elevation: 4,
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                      contentPadding:
                                          EdgeInsets.fromLTRB(10, 10, 10, 10),
                                      isThreeLine: true,
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text("Condominio: ",
                                              style: GoogleFonts.titilliumWeb(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20)),
                                          Text(
                                              snapshot.data.docs[i]
                                                  .data()['condominium']
                                                  .toString(),
                                              style: GoogleFonts.titilliumWeb(
                                                  color: Colors.black,
                                                  fontSize: 20)),
                                        ],
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text("Assunto: ",
                                                  style:
                                                      GoogleFonts.titilliumWeb(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20)),
                                              Text(
                                                  snapshot.data.docs[i]
                                                      .data()['subject']
                                                      .toString(),
                                                  style:
                                                      GoogleFonts.titilliumWeb(
                                                          color: Colors.black,
                                                          fontSize: 20)),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text("Descrição:",
                                              style: GoogleFonts.titilliumWeb(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20)),
                                          Text(
                                            snapshot.data.docs[i]
                                                .data()['content'],
                                            style: GoogleFonts.titilliumWeb(
                                                color: Colors.grey,
                                                fontSize: 18),
                                            textAlign: TextAlign.left,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Aberto em:",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                              Text(formatter.format(snapshot
                                                  .data.docs[i]
                                                  .data()['dateStart']
                                                  .toDate()))
                                            ],
                                          )
                                        ],
                                      ),
                                      trailing: IconButton(
                                        alignment: Alignment.bottomRight,
                                        icon: Icon(
                                          Icons.check_circle,
                                          size: 30,
                                          color: Colors.green,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            docSelecionado = snapshot
                                                .data.docs[i]
                                                .data()['id'];
                                          });
                                          showAlertDialog(context);
                                        },
                                      ))
                                ],
                              ),
                            );
                          },
                        ),
                      );
                  }
                  return Container();
                }),
          ],
        ),
      ),
    );
  }
}
