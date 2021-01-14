import 'dart:async';

import 'package:animated_card/animated_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion_card/expansion_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'loja_controller.dart';

class LojaPage extends StatefulWidget {
  final String title;
  const LojaPage({Key key, this.title = "Loja"}) : super(key: key);

  @override
  _LojaPageState createState() => _LojaPageState();
}

class _LojaPageState extends ModularState<LojaPage, LojaController> {
  //use 'controller' variable to access controller

  final _controller = StreamController<QuerySnapshot>.broadcast();
  dynamic docSelecionado;
  String nomeUsuario;
  String condominioUsuario;
  String nomeProduto;

  Future<Stream<QuerySnapshot>> _exibirProdutos() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    Query query = db.collection("Produtos");

    Stream<QuerySnapshot> stream = query.snapshots();
    //print(_selected);

    stream.listen((dados) {
      dados.docs.forEach((element) {
        print(element.data());
      });
      _controller.add(dados);
    });
  }

  _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = await auth.currentUser;

    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot =
        await db.collection("Usuarios").doc(user.uid).get();
    String nome = snapshot.get("nome");
    String condominio = snapshot.get("condominio");
    setState(() {
      nomeUsuario = nome.toString();
      condominioUsuario = condominio;
    });
  }

  @override
  void initState() {
    _verificarUsuarioLogado();
    _exibirProdutos();
    super.initState();
  }

  _addToCart() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    db
        .collection("Meu Carrinho")
        .doc(nomeUsuario)
        .collection(condominioUsuario)
        .doc(docSelecionado.toString())
        .set({
      'id': docSelecionado,
      'criado em': Timestamp.now(),
      'condominio': condominioUsuario,
      'produto': nomeProduto,
      'nome': nomeUsuario,
      'pgConfirmado': false,
      'entregue': false,
    });
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
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
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
                          padding: EdgeInsets.all(20),
                          itemBuilder: (context, i) {
                            return new ExpansionCard(
                              leading: IconButton(
                                color: Colors.green,
                                icon: Icon(
                                  Icons.add_box,
                                ),
                                onPressed: () {
                                  docSelecionado = snapshot.data.docs[i].id;
                                  nomeProduto = snapshot.data.docs[i]
                                      .data()['nome']
                                      .toString();
                                  _addToCart();
                                },
                              ),
                              borderRadius: 20,
                              background: Image.network(
                                snapshot.data.docs[i].data()['url'].toString(),
                                fit: BoxFit.scaleDown,
                              ),
                              title: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      snapshot.data.docs[i]
                                          .data()['nome']
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 30, color: Colors.black),
                                    ),
                                    Text(
                                      snapshot.data.docs[i]
                                              .data()['preco']
                                              .toString() +
                                          " Reais",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 7),
                                  child: Text(snapshot.data.docs[i]
                                      .data()['descricao']
                                      .toString()),
                                ),
                              ],
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
