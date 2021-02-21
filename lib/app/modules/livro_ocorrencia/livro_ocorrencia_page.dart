import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
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
      body: Container(
        color: Color(0xff202020),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Text("Notificar Problemas",
                    style: GoogleFonts.titilliumWeb(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 200,
                  child: RaisedButton(
                    child: Text(
                      "ENVIAR",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    padding: EdgeInsets.only(
                        left: 32, right: 32, top: 16, bottom: 16),
                    onPressed: () {
                      setState(() {});
                    },
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
