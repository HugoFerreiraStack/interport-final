import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Chamados chamadosFromJson(String str) => Chamados.fromJson(json.decode(str));

String chamadosToJson(Chamados data) => json.encode(data.toJson());

class Chamados {
  Chamados({
    @required this.atendente,
    @required this.filial,
    @required this.numeroChamado,
    @required this.codigoCliente,
    @required this.lojaCliente,
    @required this.horaInicio,
    @required this.horaFim,
    @required this.contato,
    @required this.telefone,
    @required this.classificacao,
    @required this.codigoProduto,
    @required this.idUnico,
    @required this.ocorrencia,
    @required this.memo,
    @required this.dataEmissao,
  });

  final String atendente;
  final String filial;
  final String telefone;
  final String codigoProduto;
  final String idUnico;
  final String ocorrencia;
  final String memo;
  final String contato;
  final int classificacao;
  final int numeroChamado;
  final int codigoCliente;
  final int lojaCliente;
  final DateTime dataEmissao;
  final Timestamp horaInicio;
  final Timestamp horaFim;

  factory Chamados.fromRawJson(String str) =>
      Chamados.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Chamados.fromJson(Map<String, dynamic> json) => Chamados(
        atendente: json["atendente"],
        filial: json["filial"],
        numeroChamado: json["numeroChamado"],
        codigoCliente: json["codigoCliente"],
        lojaCliente: json["lojaCliente"],
        horaInicio: json["horaInicio"],
        horaFim: json["horaFim"],
        contato: json["contato"],
        telefone: json["telefone"],
        classificacao: json["classificacao"],
        codigoProduto: json["codigoProduto"],
        idUnico: json["idUnico"],
        ocorrencia: json["ocorrencia"],
        memo: json["memo"],
        dataEmissao: json["dataEmissao"],
      );

  Map<String, dynamic> toJson() => {
        "atendente": atendente,
        "filial": filial,
        "numeroChamado": numeroChamado,
        "codigoCliente": codigoCliente,
        "lojaCliente": lojaCliente,
        "horaInicio": horaInicio,
        "horaFim": horaFim,
        "contato": contato,
        "telefone": telefone,
        "classificacao": classificacao,
        "codigoProduto": codigoProduto,
        "idUnico": idUnico,
        "ocorrencia": ocorrencia,
        "memo": memo,
        "dataEmissao": dataEmissao,
      };
}
