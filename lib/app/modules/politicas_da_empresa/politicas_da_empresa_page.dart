import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'politicas_da_empresa_controller.dart';

class PoliticasDaEmpresaPage extends StatefulWidget {
  final String title;
  const PoliticasDaEmpresaPage({Key key, this.title = "PoliticasDaEmpresa"})
      : super(key: key);

  @override
  _PoliticasDaEmpresaPageState createState() => _PoliticasDaEmpresaPageState();
}

class _PoliticasDaEmpresaPageState
    extends ModularState<PoliticasDaEmpresaPage, PoliticasDaEmpresaController> {
  //use 'controller' variable to access controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[],
      ),
    );
  }
}
