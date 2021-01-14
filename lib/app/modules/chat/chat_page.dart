import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'chat_controller.dart';

class ChatPage extends StatefulWidget {
  final String title;
  const ChatPage({Key key, this.title = "Chat"}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends ModularState<ChatPage, ChatController> {
  //use 'controller' variable to access controller
  ScrollController _scrollController = new ScrollController();
  TextEditingController _chatTextController = new TextEditingController();

  bool _hasText = false;

  String _name = '';
  bool isComposing = false;
  final _controller = StreamController<QuerySnapshot>.broadcast();
  final formKeyChat = GlobalKey<FormState>();
  String condominioUsuario;
  String nomeUsuario;
  String sindico;
  String mensagem;
  String from;
  String tipoUsuario;

  void _handleChatSubmit(String text) {
    _chatTextController.clear();
    FirebaseFirestore.instance.collection('Mensagens').add({
      'remetente': nomeUsuario,
      'mensagem': text,
      'condominio': condominioUsuario,
      'tipoUsuario': tipoUsuario,
      'lida': false,
      'timestamp': new DateTime.now()
    });
  }

  _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = await auth.currentUser;

    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot =
        await db.collection("Usuarios").doc(user.uid).get();
    String condominio = snapshot.get("condominio");
    String nome = snapshot.get("nome");
    String tipo = snapshot.get("tipoUsuario");

    setState(() {
      condominioUsuario = condominio;
      nomeUsuario = nome;
      tipoUsuario = tipo;
    });

    _buscarSindicos();
  }

  Widget buildChatList() {
    return new Expanded(
        child: new StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Mensagens')
                .orderBy("timestamp", descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Text('Carregando...');
              return new ListView.builder(
                  controller: _scrollController,
                  itemCount: snapshot.data.documents.length,
                  padding: const EdgeInsets.only(top: 10.0),
                  itemBuilder: (context, index) {
                    SchedulerBinding.instance.addPostFrameCallback((duration) {
                      _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    });
                    DocumentSnapshot ds = snapshot.data.documents[index];
                    print("documentChange received? ${ds['mensagem']}");
                    return buildChatBubble(ds['remetente'], ds['mensagem']);
                  });
            }));
  }

  Widget buildChatBar() {
    return new Container(
        padding: new EdgeInsets.all(15.0),
        color: Colors.white,
        child: new Row(
          children: <Widget>[
            new Expanded(
                child: new TextField(
              controller: _chatTextController,
              decoration:
                  new InputDecoration.collapsed(hintText: "Enviar mensagem"),
              onChanged: (text) {
                setState(() {
                  _hasText = text.length > 0;
                });
              },
            )),
            new IconButton(
              icon: new Icon(Icons.send),
              onPressed: _hasText
                  ? () {
                      _handleChatSubmit(_chatTextController.text);
                    }
                  : null,
            )
          ],
        ));
  }

  Widget buildChatBubble(String remetente, String mensagem) {
    const whiteText = const TextStyle(color: Colors.white, fontSize: 15.0);

    return new Container(
      margin: new EdgeInsets.all(5.0),
      decoration: new BoxDecoration(
          color: Color(0xFF1E1C3F),
          borderRadius: new BorderRadius.all(const Radius.circular(8.0))),
      padding: new EdgeInsets.all(10.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            "${remetente}: ",
            style: whiteText,
          ),
          new Text(mensagem, style: whiteText)
        ],
      ),
    );
  }

  Future<Stream<QuerySnapshot>> _buscarSindicos() async {
    FirebaseFirestore.instance
        .collection('Usuarios')
        .where('condominio', isEqualTo: condominioUsuario)
        .snapshots()
        .listen((result) {
      result.docs.forEach((result) {
        setState(() {
          sindico = result.data()['nome'];
        });
        print(sindico);
      });
    });
  }

  _enviarMensagem() async {
    FirebaseFirestore.instance
        .collection("Mensagens")
        .doc(condominioUsuario)
        .collection(nomeUsuario)
        .doc("mensagem")
        .set({
      "mensagem": mensagem,
      "from": from,
      "read": false,
    });
  }

  @override
  void initState() {
    _verificarUsuarioLogado();
    _buscarSindicos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[buildChatList(), buildChatBar()],
        ),
      ),
    );
  }
}
