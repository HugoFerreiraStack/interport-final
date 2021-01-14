import 'dart:async';
import 'dart:typed_data';
import 'package:animated_card/animated_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'home_controller.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key key, this.title = "Home"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeController> {
  //use 'controller' variable to access controller
  final FirebaseStorage storage = FirebaseStorage(
      app: Firestore.instance.app,
      storageBucket: 'gs://interport-02.appspot.com/');

  final _controller = StreamController<QuerySnapshot>.broadcast();
  String condominioUsuario;
  String content;
  String numeroCentral;

  Uint8List imageBytes;
  String errorMsg;

  _recuperarNumeroCentral() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot =
        await db.collection("SoftPhone").doc("numeroCentral").get();
    String number = snapshot.get("contatoCentral");
    setState(() {
      numeroCentral = number;
      print(numeroCentral);
    });
  }

  Future<void> logout() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.signOut() as User;
  }

  _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = await auth.currentUser;

    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot =
        await db.collection("Usuarios").doc(user.uid).get();
    String condominio = snapshot.get("condominio");

    setState(() {
      condominioUsuario = condominio;
    });
    downloadImage();
    _buscarComunicados();
    _recuperarNumeroCentral();
  }

  downloadImage() async {
    storage
        .ref()
        .child(condominioUsuario)
        .child('/banner.jpg')
        .getData(10000000)
        .then((data) => setState(() {
              imageBytes = data;
            }))
        .catchError((e) => setState(() {
              errorMsg = e.error;
            }));
  }

  Future<Stream<QuerySnapshot>> _buscarComunicados() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    Query query = db
        .collection("Comunicados")
        .where("condominio", isEqualTo: condominioUsuario);

    Stream<QuerySnapshot> stream = query.snapshots();
    //print(_selected);

    stream.listen((dados) {
      dados.docs.forEach((element) {
        print(element.data());
      });
      _controller.add(dados);
    });
  }

  @override
  void initState() {
    _verificarUsuarioLogado();
    _buscarComunicados();
    downloadImage();
    _recuperarNumeroCentral();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var img = imageBytes != null
        ? Image.memory(
            imageBytes,
            fit: BoxFit.contain,
            scale: 2,
          )
        : Text(errorMsg != null ? errorMsg : "Carregando...");
    var carregandoDados = Center(
      child: Column(
        children: <Widget>[CircularProgressIndicator()],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "Feed",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.red,
          ),
          onPressed: () {
            logout();
            Modular.to.pushReplacementNamed('/login');
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton.extended(
                  heroTag: "btn1",
                  backgroundColor: Color(0xFF1E1C3F),
                  icon: Icon(
                    Icons.store,
                    size: 15,
                  ),
                  label: Text(
                    "Loja",
                    style: TextStyle(fontSize: 10),
                  ),
                  onPressed: () {
                    Modular.to.pushNamed('/loja');
                  },
                ),
                SizedBox(
                  width: 5,
                ),
                FloatingActionButton.extended(
                  heroTag: "btn2",
                  backgroundColor: Color(0xFF1E1C3F),
                  icon: Icon(
                    Icons.calendar_today,
                    size: 15,
                  ),
                  label: Text(
                    "Eventos",
                    style: TextStyle(fontSize: 10),
                  ),
                  onPressed: () {
                    Modular.to.pushNamed("eventos");
                  },
                ),
                SizedBox(
                  width: 5,
                ),
                FloatingActionButton.extended(
                  heroTag: "btn3",
                  backgroundColor: Color(0xFF1E1C3F),
                  icon: Icon(
                    Icons.call,
                    size: 15,
                  ),
                  label: Text(
                    "Central",
                    style: TextStyle(fontSize: 10),
                  ),
                  onPressed: () async {
                    FlutterPhoneDirectCaller.callNumber(numeroCentral);
                  },
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Comunicados",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                FlatButton(
                  onPressed: () {},
                  child: Text(
                    "Ver todos",
                    style: TextStyle(color: Colors.cyan),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[img],
            ),
            SizedBox(
              height: 10,
            ),
            StreamBuilder(
                stream: _controller.stream,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return carregandoDados;
                      break;
                    case ConnectionState.active:
                    case ConnectionState.done:
                      QuerySnapshot querySnapshot = snapshot.data;
                      if (querySnapshot.docs.length == 0) {
                        return Container(
                          padding: EdgeInsets.all(25),
                          child: Text(
                            "",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          padding: EdgeInsets.all(5),
                          itemBuilder: (context, i) {
                            return new AnimatedCard(
                                direction: AnimatedCardDirection
                                    .left, //Initial animation direction
                                initDelay: Duration(
                                    milliseconds:
                                        0), //Delay to initial animation
                                duration: Duration(seconds: 1), //Initial anima
                                curve: Curves.bounceOut,
                                child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Card(
                                        elevation: 2,
                                        child: ListTile(
                                          title: Container(
                                            height: 50,
                                            child: Text(
                                              snapshot.data.docs[i]
                                                  .data()['title']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          subtitle: Text(
                                            snapshot.data.docs[i]
                                                .data()['content']
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                        ))));
                          },
                        ),
                      );
                  }
                  return Container();
                }),
          ],
        ),
      ),
    );
  }
}
