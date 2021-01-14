import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'visitas_controller.dart';

class VisitasPage extends StatefulWidget {
  final String title;
  const VisitasPage({Key key, this.title = "Visitas"}) : super(key: key);

  @override
  _VisitasPageState createState() => _VisitasPageState();
}

class _VisitasPageState extends ModularState<VisitasPage, VisitasController> {
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
