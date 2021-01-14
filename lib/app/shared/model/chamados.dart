import 'package:cloud_firestore/cloud_firestore.dart';

class Chamados {
  String _id;
  String _subject;
  String _content;
  String _condominium;
  Timestamp _dateStart;
  Timestamp _dateFinish;
  bool _finish;

  Chamados();

  Chamados.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    this.id = documentSnapshot.id;
    this.subject = documentSnapshot['subject'];
    this.content = documentSnapshot['content'];
    this.condominium = documentSnapshot['condominium'];
    this.dateStart = documentSnapshot['dateStart'];
    this.dateFinish = documentSnapshot["dateFinish"];
    this.finish = documentSnapshot['finish'];
  }

  Chamados.generateID() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference chamados = db.collection("Chamados");
    this.id = chamados.doc().id;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": this.id,
      "subject": this.subject,
      "content": this.content,
      "condominium": this.condominium,
      "dateStart": this.dateStart,
      "dateFinish": this.dateFinish,
      "finish": this.finish,
    };
    return map;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get subject => _subject;

  set subject(String value) {
    _subject = value;
  }

  String get content => _content;

  set content(String value) {
    _content = value;
  }

  String get condominium => _condominium;

  set condominium(String value) {
    _condominium = value;
  }

  Timestamp get dateStart => _dateStart;

  set dateStart(Timestamp value) {
    _dateStart = value;
  }

  Timestamp get dateFinish => _dateFinish;

  set dateFinish(Timestamp value) {
    _dateFinish = value;
  }

  bool get finish => _finish;

  set finish(bool value) {
    _finish = value;
  }
}
