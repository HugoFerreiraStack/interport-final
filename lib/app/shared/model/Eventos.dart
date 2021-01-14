import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Evento {
  String _id;
  String _moradorResponsavel;
  String _nomeEvento;
  String _condominio;
  String _espaco;
  String _descricao;
  String _data;
  String _horaInicial;
  String _horaFinal;
  bool _status;

  Evento();

  Evento.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    this.id = documentSnapshot.id;
    this.moradorResponsavel = documentSnapshot['moradorResponsavel'];
    this.nomeEvento = documentSnapshot['nomeEvento'];
    this.condominio = documentSnapshot['condominio'];
    this.espaco = documentSnapshot['espaco'];
    this.descricao = documentSnapshot['descricao'];
    this.data = documentSnapshot['data'];
    this.horaInicial = documentSnapshot['horaInicial'];
    this.horaFinal = documentSnapshot['horaFinal'];
    this.status = documentSnapshot['status'];
  }

  Evento.gerarID() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference eventos = db.collection("Eventos");
    this.id = eventos.doc().id;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": this.id,
      "moradorResponsavel": this.moradorResponsavel,
      "nomeEvento": this.nomeEvento,
      "condominio": this.condominio,
      "espaco": this.espaco,
      "descricao": this.descricao,
      "data": this.data,
      "horaInicial": this.horaInicial,
      "horaFinal": this.horaFinal,
      "status": this.status,
    };
    return map;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get moradorResponsavel => _moradorResponsavel;

  set moradorResponsavel(String value) {
    _moradorResponsavel = value;
  }

  String get nomeEvento => _nomeEvento;

  set nomeEvento(String value) {
    _nomeEvento = value;
  }

  String get condominio => _condominio;

  set condominio(String value) {
    _condominio = value;
  }

  String get espaco => _espaco;

  set espaco(String value) {
    _espaco = value;
  }

  String get descricao => _descricao;

  set descricao(String value) {
    _descricao = value;
  }

  String get data => _data;

  set data(String value) {
    _data = value;
  }

  String get horaInicial => _horaInicial;

  set horaInicial(String value) {
    _horaInicial = value;
  }

  String get horaFinal => _horaFinal;

  set horaFinal(String value) {
    _horaFinal = value;
  }

  bool get status => _status;

  set status(bool value) {
    _status = value;
  }
}
