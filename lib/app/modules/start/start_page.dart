import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:interport_app/app/modules/cameras/cameras_module.dart';
import 'package:interport_app/app/modules/chat/chat_module.dart';
import 'package:interport_app/app/modules/eventos/eventos_module.dart';
import 'package:interport_app/app/modules/home/home_module.dart';
import 'package:interport_app/app/modules/loja/loja_module.dart';
import 'package:interport_app/app/modules/panico/panico_module.dart';
import 'package:interport_app/app/modules/visitas/visitas_module.dart';
import 'start_controller.dart';

class StartPage extends StatefulWidget {
  final String title;
  const StartPage({Key key, this.title = "Start"}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends ModularState<StartPage, StartController> {
  //use 'controller' variable to access controller

  List widgetOptions = [
    HomeModule(),
    CamerasModule(),
    PanicoModule(),
    ChatModule(),
    VisitasModule(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(
        builder: (_) {
          return widgetOptions.elementAt(controller.currentIndex);
        },
      ),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  Widget bottomNavigationBar() {
    return Observer(builder: (_) {
      return CurvedNavigationBar(
        index: controller.currentIndex,
        onTap: (index) {
          controller.upDateCurrentIndex(index);
        },
        items: <Widget>[
          Icon(
            Icons.home,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.camera_alt,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.adjust,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.chat,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.people_alt,
            size: 30,
            color: Colors.white,
          ),
        ],
        color: Color(0xFF1E1C3F),
        buttonBackgroundColor: Color(0xFF1E1C3F),
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
      );
    });
  }
}
