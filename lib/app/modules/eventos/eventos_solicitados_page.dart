import 'dart:async';

import 'package:animated_card/animated_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventosSolicitadosPage extends StatefulWidget {
  @override
  _EventosSolicitadosPageState createState() => _EventosSolicitadosPageState();
}

class _EventosSolicitadosPageState extends State<EventosSolicitadosPage> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  dynamic docSelecionado;
  bool confirmar = false;

  Future<Stream<QuerySnapshot>> _buscarEventos() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    Query query = db.collection("Eventos").where("status", isEqualTo: false);

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
        .collection("Eventos")
        .doc("Jardim dos Manacas")
        .collection("eventos")
        .doc(selectedDoc)
        .update(newValue)
        .catchError((e) {
      print(e);
    });
  }

  @override
  void initState() {
    _buscarEventos();
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
                            return new AnimatedCard(
                                direction: AnimatedCardDirection
                                    .left, //Initial animation direction
                                initDelay: Duration(
                                    milliseconds:
                                        0), //Delay to initial animation
                                duration: Duration(seconds: 1), //Initial anima
                                curve: Curves.bounceOut,
                                child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Card(
                                        elevation: 2,
                                        child: ListTile(
                                          title: Container(
                                            height: 50,
                                            child: Text(
                                              snapshot.data.docs[i]
                                                  .data()['moradorResponsavel']
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Color(0xFF1E1C3F),
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          subtitle: Text(
                                            snapshot.data.docs[i]
                                                .data()['condominio']
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                          trailing: Checkbox(
                                            value: snapshot.data.docs[i]
                                                .data()['status'],
                                            onChanged: (bool value) {
                                              docSelecionado =
                                                  snapshot.data.docs[i].id;
                                              confirmar = value;
                                              _updateData(docSelecionado,
                                                  {"status": confirmar});
                                            },
                                          ),
                                        ))));
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
