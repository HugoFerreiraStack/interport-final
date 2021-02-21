import 'package:cloud_firestore/cloud_firestore.dart';

class Condominio {
  String _id;
  String _nome;
  String _cidade;
  String _bairro;
  String _rua;
  String _qtdBlocos;
  String _qtdApts;
  bool _churrasqueira;
  bool _salaoDeFestas;
  bool _salaDeJogos;
  bool _academia;
  bool _quadraDeTenis;
  bool _quadraFutsal;
  bool _piscina;

  Condominio();

  Condominio.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    this.id = documentSnapshot.id;
    this.nome = documentSnapshot['nome'];
    this.cidade = documentSnapshot['cidade'];
    this.bairro = documentSnapshot['bairro'];
    this.rua = documentSnapshot['rua'];
    this.qtdBlocos = documentSnapshot['qtdBlocos'];
    this.qtdApts = documentSnapshot['qtdApts'];
    this.churrasqueira = documentSnapshot['churrasqueira'];
    this.salaoDeFestas = documentSnapshot['salaoDeFestas'];
    this.academia = documentSnapshot['academia'];
    this.quadraDeTenis = documentSnapshot['quadraDeTenis'];
    this.quadraFutsal = documentSnapshot['quadraFutsal'];
    this.piscina = documentSnapshot['piscina'];
    this.salaDeJogos = documentSnapshot['salaDeJogos'];
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
      "rua": this.rua,
      "qtdBlocos": this.qtdBlocos,
      "qtdApts": this.qtdApts,
      "churrasqueira": this.churrasqueira,
      "salaoDeFestas": this.salaoDeFestas,
      "academia": this.academia,
      "quadraDeTenis": this.quadraDeTenis,
      "quadraFutsal": this.quadraFutsal,
      "piscina": this.piscina,
      "salaDeJogos": this.salaDeJogos,
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

  String get rua => _rua;

  set rua(String value) {
    _rua = value;
  }

  String get qtdBlocos => _qtdBlocos;

  set qtdBlocos(String value) {
    _qtdBlocos = value;
  }

  String get qtdApts => _qtdApts;

  set qtdApts(String value) {
    _qtdApts = value;
  }

  bool get churrasqueira => _churrasqueira;

  set churrasqueira(bool value) {
    _churrasqueira = value;
  }

  bool get salaoDeFestas => _salaoDeFestas;

  set salaoDeFestas(bool value) {
    _salaoDeFestas = value;
  }

  bool get academia => _academia;

  set academia(bool value) {
    _academia = value;
  }

  bool get quadraDeTenis => _quadraDeTenis;

  set quadraDeTenis(bool value) {
    _quadraDeTenis = value;
  }

  bool get quadraFutsal => _quadraFutsal;

  set quadraFutsal(bool value) {
    _quadraFutsal = value;
  }

  bool get piscina => _piscina;

  set piscina(bool value) {
    _piscina = value;
  }

  bool get salaDeJogos => _salaDeJogos;

  set salaDeJogos(bool value) {
    _salaDeJogos = value;
  }
}
