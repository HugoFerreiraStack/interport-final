import 'package:cloud_firestore/cloud_firestore.dart';

class Produto {
  String _id;
  String _codigo;
  String _nome;
  String _preco;
  String _descricao;
  String _quantidade;
  String _url;

  Produto();

  Produto.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    this.id = documentSnapshot.id;
    this.codigo = documentSnapshot['codigo'];
    this.nome = documentSnapshot['nome'];
    this.preco = documentSnapshot['preco'];
    this.descricao = documentSnapshot['descricao'];
    this.quantidade = documentSnapshot['quantidade'];
    this.url = documentSnapshot['url'];
  }

  Produto.gerarID() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference produtos = db.collection("Produtos");
    this.id = produtos.doc().id;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": this.id,
      "codigo": this.codigo,
      "nome": this.nome,
      "preco": this.preco,
      "descricao": this.descricao,
      "quantidade": this.quantidade,
      "url": this.url,
    };
    return map;
  }

  String get id => _id;
  set id(String value) {
    _id = value;
  }

  String get codigo => _codigo;
  set codigo(String value) {
    _codigo = value;
  }

  String get nome => _nome;
  set nome(String value) {
    _nome = value;
  }

  String get preco => _preco;
  set preco(String value) {
    _preco = value;
  }

  String get descricao => _descricao;
  set descricao(String value) {
    _descricao = value;
  }

  String get quantidade => _quantidade;
  set quantidade(String value) {
    _quantidade = value;
  }

  String get url => _url;
  set url(String value) {
    _url = value;
  }
}
