import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'splash_screen_controller.dart';

class SplashScreenPage extends StatefulWidget {
  final String title;
  const SplashScreenPage({Key key, this.title = "SplashScreen"})
      : super(key: key);

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState
    extends ModularState<SplashScreenPage, SplashScreenController> {
  ReactionDisposer disposer;

  @override
  void initState() {
    super.initState();
    Intl.defaultLocale = 'pt_BR';
    disposer = autorun((_) {
      Future.delayed(Duration(seconds: 5)).then((_) {
        Modular.to.pushReplacementNamed('/login');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xFF1E1C3F)),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 0, top: 80),
                  child: Image.asset(
                    "images/logo_splash.png",
                    width: 180,
                    height: 180,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 100, bottom: 3),
                  child: Text(
                    "O seu condomínio na palma das mãos",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 5),
                  child: Text(
                    "Tudo o que você precisa saber do seu condomínio em um só lugar.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 180, bottom: 5),
                  child: Text(
                    " \u00a9 Interport 2021 ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
