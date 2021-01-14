import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'livro_ocorrencia_controller.dart';

class LivroOcorrenciaPage extends StatefulWidget {
  final String title;
  const LivroOcorrenciaPage({Key key, this.title = "LivroOcorrencia"})
      : super(key: key);

  @override
  _LivroOcorrenciaPageState createState() => _LivroOcorrenciaPageState();
}

class _LivroOcorrenciaPageState
    extends ModularState<LivroOcorrenciaPage, LivroOcorrenciaController> {
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
