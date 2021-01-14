import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ChamadosFinalizadosPage extends StatefulWidget {
  @override
  _ChamadosFinalizadosPageState createState() =>
      _ChamadosFinalizadosPageState();
}

class _ChamadosFinalizadosPageState extends State<ChamadosFinalizadosPage> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  DateFormat formatter = DateFormat('dd/MM/yyyy   hh:mm a');

  Future<Stream<QuerySnapshot>> _exibirChamados() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    Query query = db
        .collection("Chamados")
        .where('finish', isEqualTo: true)
        .orderBy('dateFinish', descending: true);

    Stream<QuerySnapshot> stream = query.snapshots();
    //print(_selected);

    stream.listen((dados) {
      dados.docs.forEach((element) {
        print(element.data());
      });
      _controller.add(dados);
    });
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
        title: Text("Chamados Finalizados"),
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
                                                style: GoogleFonts.titilliumWeb(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20)),
                                            Text(
                                                snapshot.data.docs[i]
                                                    .data()['subject']
                                                    .toString(),
                                                style: GoogleFonts.titilliumWeb(
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
                                              .data()['content']
                                              .toString(),
                                          style: GoogleFonts.titilliumWeb(
                                              color: Colors.grey, fontSize: 18),
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
                                              "Aberto em: ",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              formatter.format(snapshot
                                                  .data.docs[i]
                                                  .data()['dateStart']
                                                  .toDate()),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Finalizado em: ",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              formatter.format(snapshot
                                                  .data.docs[i]
                                                  .data()['dateFinish']
                                                  .toDate()),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
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
