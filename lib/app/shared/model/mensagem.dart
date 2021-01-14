import 'package:cloud_firestore/cloud_firestore.dart';

class Mensagem {
  String _id;
  String _remetente;
  String _mensagem;
  String _condominio;
  String _tipoUsuario;
  bool _lida;

  Mensagem();

  Mensagem.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    this.id = documentSnapshot['id'];
    this.remetente = documentSnapshot['remetente'];
    this.mensagem = documentSnapshot['mensagem'];
    this.condominio = documentSnapshot['condominio'];
    this.tipoUsuario = documentSnapshot['tipoUsuario'];
    this.lida = documentSnapshot['lida'];
  }

  Mensagem.gerarID() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference eventos = db.collection("Mensagens");
    this.id = eventos.doc().id;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": this.id,
      "remetente": this.remetente,
      "mensagem": this.mensagem,
      "condominio": this.condominio,
      "tipoUsuario": this.tipoUsuario,
      "lida": this.lida,
    };
    return map;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get remetente => _remetente;

  set remetente(String value) {
    _remetente = value;
  }

  String get mensagem => _mensagem;

  set mensagem(String value) {
    _mensagem = value;
  }

  String get condominio => _condominio;

  set condominio(String value) {
    _condominio = value;
  }

  String get tipoUsuario => _tipoUsuario;

  set tipoUsuario(String value) {
    _tipoUsuario = value;
  }

  bool get lida => _lida;

  set lida(bool value) {
    _lida = value;
  }
}
