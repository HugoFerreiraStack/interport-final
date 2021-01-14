import 'package:cloud_firestore/cloud_firestore.dart';

class Comunicado {
  String _id;
  String _title;
  String _content;
  String _condominio;
  Timestamp _data;

  Comunicado();

  Comunicado.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    this.id = documentSnapshot.id;
    this.title = documentSnapshot['title'];
    this.content = documentSnapshot['content'];
    this.condominio = documentSnapshot["condominio"];
    this.data = documentSnapshot['data'];
  }

  Comunicado.gerarID() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference eventos = db.collection("Comunicados");
    this.id = eventos.doc().id;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": this.id,
      "title": this.title,
      "content": this.content,
      "condominio": this.condominio,
      "data": this.data,
    };
    return map;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get content => _content;

  set content(String value) {
    _content = value;
  }

  String get condominio => _condominio;

  set condominio(String value) {
    _condominio = value;
  }

  Timestamp get data => _data;

  set data(Timestamp value) {
    _data = value;
  }
}
