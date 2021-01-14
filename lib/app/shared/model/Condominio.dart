import 'package:cloud_firestore/cloud_firestore.dart';

class Condominio {
  String _id;
  String _nome;
  String _cidade;
  String _bairro;
  String _qtdBlocos;
  String _qtdApts;

  Condominio();

  Condominio.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    this.id = documentSnapshot.id;
    this.nome = documentSnapshot['nome'];
    this.cidade = documentSnapshot['cidade'];
    this.bairro = documentSnapshot['bairro'];
    this.qtdBlocos = documentSnapshot['qtdBlocos'];
    this.qtdApts = documentSnapshot['qtdApts'];
  }

  Condominio.gerarID() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference condominios = db.collection("Condominios");
    this.id = condominios.doc().id;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": this.id,
      "nome": this.nome,
      "cidade": this.cidade,
      "bairro": this.bairro,
      "qtdBlocos": this.qtdBlocos,
      "qtdApts": this.qtdApts,
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

  String get cidade => _cidade;

  set cidade(String value) {
    _cidade = value;
  }

  String get bairro => _bairro;

  set bairro(String value) {
    _bairro = value;
  }

  String get qtdBlocos => _qtdBlocos;

  set qtdBlocos(String value) {
    _qtdBlocos = value;
  }

  String get qtdApts => _qtdApts;

  set qtdApts(String value) {
    _qtdApts = value;
  }
}
