import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class Navbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return DesktopNavbar();
        } else if (constraints.maxWidth > 800 && constraints.maxWidth < 1200) {
          return DesktopNavbar();
        } else {
          return MobileNavbar();
        }
      },
    );
  }
}

class DesktopNavbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Interport",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 30),
            ),
            Row(
              children: <Widget>[
                MaterialButton(
                  hoverColor: Colors.blue,
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  onPressed: () async {
                    await Modular.to.pushReplacementNamed('/admin');
                  },
                  child: Text(
                    "Home",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                MaterialButton(
                  hoverColor: Colors.blue,
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  onPressed: () async {
                    await Modular.to.pushReplacementNamed('/banner');
                  },
                  child: Text(
                    "Banner Informativo",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                MaterialButton(
                  hoverColor: Colors.blue,
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  onPressed: () async {
                    await Modular.to.pushReplacementNamed('/cad_condominio');
                  },
                  child: Text(
                    "Condomínios",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                MaterialButton(
                  hoverColor: Colors.blue,
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  onPressed: () {},
                  child: Text(
                    "Eventos",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                MaterialButton(
                  hoverColor: Colors.blue,
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  onPressed: () async {
                    await Modular.to.pushReplacementNamed('/ocorrencia');
                  },
                  child: Text(
                    "Livro de Ocorrência",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                MaterialButton(
                  hoverColor: Colors.blue,
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  onPressed: () {},
                  child: Text(
                    "Visita Segura",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MobileNavbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: Container(
        child: Column(children: <Widget>[
          Text(
            "Interport",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 30),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  hoverColor: Colors.blue,
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  onPressed: () {},
                  child: Text(
                    "Home",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                MaterialButton(
                  hoverColor: Colors.blue,
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  onPressed: () {},
                  child: Text(
                    "Banner Informativo",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                MaterialButton(
                  hoverColor: Colors.blue,
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  onPressed: () {},
                  child: Text(
                    "Condomínios",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                MaterialButton(
                  hoverColor: Colors.blue,
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  onPressed: () {},
                  child: Text(
                    "Eventos",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                MaterialButton(
                  hoverColor: Colors.blue,
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  onPressed: () {},
                  child: Text(
                    "Livro de Ocorrência",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                MaterialButton(
                  hoverColor: Colors.blue,
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  onPressed: () {},
                  child: Text(
                    "Visita Segura",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
