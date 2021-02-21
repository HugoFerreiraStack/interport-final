import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:interport_app/app/shared/landing_page.dart';
import 'package:interport_app/app/shared/nav_bar.dart';
import 'admin_controller.dart';

class AdminPage extends StatefulWidget {
  final String title;
  const AdminPage({Key key, this.title = "Admin"}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends ModularState<AdminPage, AdminController> {
  //use 'controller' variable to access controller

  String _nomeUsuario = "";

  _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot =
        await db.collection("Usuarios").doc(user.uid.toString()).get();
    String nome = snapshot.get("nome");
    setState(() {
      _nomeUsuario = nome;
      print(_nomeUsuario);
    });
  }

  Future<void> logout() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.signOut() as User;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _verificarUsuarioLogado();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFF1E1C3F), Colors.black]),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Navbar(),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 95.0, horizontal: 40.0),
                child: LandingPage(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
