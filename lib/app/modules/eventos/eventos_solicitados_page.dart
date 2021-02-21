import 'dart:async';

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
          ],
        ),
      ),
    );
  }
}
