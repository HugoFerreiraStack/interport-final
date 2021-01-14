import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  String _id;
  String _nome;
  String _email;
  String _telefone;
  String _senha;
  String _condominio;
  String _apartamento;
  String _bloco;
  String _tipoUsuario;
  String _urlImage;
  bool _master;
  DateTime _lastMessageTime;

  Usuario();

  Usuario.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    this.id = documentSnapshot.id;
    this.nome = documentSnapshot['nome'];
    this.email = documentSnapshot['email'];
    this.telefone = documentSnapshot['telefone'];
    this.condominio = documentSnapshot['condominio'];
    this.bloco = documentSnapshot['bloco'];
    this.apartamento = documentSnapshot['apartamento'];
    this.tipoUsuario = documentSnapshot['tipoUsuario'];
    this.urlImage = documentSnapshot['urlImage'];
    this.master = documentSnapshot['master'];
    this.lastMessageTime = documentSnapshot['lastMessageTime'];
  }

  Usuario.gerarID() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference condominios = db.collection("Usuarios");
    this.id = condominios.doc().id;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": this.id,
      "nome": this.nome,
      "email": this.email,
      "telefone": this.telefone,
      "condominio": this.condominio,
      "bloco": this.bloco,
      "apartamento": this.apartamento,
      "tipoUsuario": this.tipoUsuario,
      "urlImage": this.urlImage,
      "master": this.master,
      "lastMessageTime": this.lastMessageTime,
    };
    return map;
  }

  String get id => _id;
  set id(String value) {
    _id = value;
  }

  String get nome => _nome;
  set nome(String value) {
    _nome = value;
  }

  String get email => _email;
  set email(String value) {
    _email = value;
  }

  String get telefone => _telefone;
  set telefone(String value) {
    _telefone = value;
  }

  String get bloco => _bloco;
  set bloco(String value) {
    _bloco = value;
  }

  String get senha => _senha;
  set senha(String value) {
    _senha = value;
  }

  String get condominio => _condominio;
  set condominio(String value) {
    _condominio = value;
  }

  String get apartamento => _apartamento;
  set apartamento(String value) {
    _apartamento = value;
  }

  String get tipoUsuario => _tipoUsuario;
  set tipoUsuario(String value) {
    _tipoUsuario = value;
  }

  String get urlImage => _urlImage;
  set urlImage(String value) {
    _urlImage = value;
  }

  bool get master => _master;
  set master(bool value) {
    _master = value;
  }

  DateTime get lastMessageTime => _lastMessageTime;
  set lastMessageTime(DateTime value) {
    _lastMessageTime = value;
  }
}
