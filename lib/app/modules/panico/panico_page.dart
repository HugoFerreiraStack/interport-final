import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'panico_controller.dart';

class PanicoPage extends StatefulWidget {
  final String title;
  const PanicoPage({Key key, this.title = "Panico"}) : super(key: key);

  @override
  _PanicoPageState createState() => _PanicoPageState();
}

class _PanicoPageState extends ModularState<PanicoPage, PanicoController> {
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
