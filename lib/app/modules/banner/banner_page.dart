import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_ink_well/image_ink_well.dart';
import 'package:interport_app/app/shared/model/banner.dart';
import 'package:interport_app/app/shared/nav_bar.dart';
import 'banner_controller.dart';
import 'package:firebase/firebase.dart' as fb;

class BannerPage extends StatefulWidget {
  final String title;
  const BannerPage({Key key, this.title = "Banner"}) : super(key: key);

  @override
  _BannerPageState createState() => _BannerPageState();
}

class _BannerPageState extends ModularState<BannerPage, BannerController> {
  //use 'controller' variable to access controller

  File imageFile;
  fb.UploadTask _uploadTask;
  var condominioSelecionado;
  String _condomino = "";
  String _urlImage;

  uploadImage() async {
    // HTML input element
    InputElement uploadInput = FileUploadInputElement();
    uploadInput.click();

    uploadInput.onChange.listen(
      (changeEvent) {
        final file = uploadInput.files.first;
        final reader = FileReader();

        reader.readAsDataUrl(file);

        reader.onLoadEnd.listen(
          // After file finiesh reading and loading, it will be uploaded to firebase storage
          (loadEndEvent) async {
            uploadToFirebase(file);
          },
        );
      },
    );
  }

  uploadToFirebase(File imageFile) async {
    setState(() {
      _uploadTask = fb
          .storage()
          .refFromURL('gs://interport-02.appspot.com/')
          .child(_condomino)
          .child('/banner.png')
          .put(imageFile);
    });
    Future.delayed(const Duration(milliseconds: 2000), () {
      printUrl();
    });
  }

  printUrl() async {
    fb.StorageReference ref = fb
        .storage()
        .refFromURL('gs://interport-02.appspot.com/')
        .child(_condomino)
        .child('/banner.png');
    String url = (await ref.getDownloadURL()).toString();
    setState(() {
      _urlImage = url;
    });
  }

  _postBanner() {
    if (_urlImage != null) {
      BannerPost bannerPost = BannerPost(
          url: _urlImage, condominio: condominioSelecionado.toString());
      FirebaseFirestore db = FirebaseFirestore.instance;

      db
          .collection("Banner Informativo")
          .doc(condominioSelecionado.toString())
          .set(bannerPost.toJson());
      setState(() {
        _urlImage = "";
        condominioSelecionado = null;
      });
    }
  }

  Widget _bannerImage() {
    if (_urlImage == null) {
      return ImageInkWell(
        height: 250,
        width: 250,
        onPressed: () {
          uploadImage();
        },
        image: AssetImage("images/noimage.jpg"),
      );
    } else {
      return ImageInkWell(
        image: NetworkImage(_urlImage),
        onPressed: () {
          uploadImage();
        },
        height: 250,
        width: 250,
        fit: BoxFit.contain,
      );
    }
  }

  Widget _rigthSidePage() {
    return Container(
        width: MediaQuery.of(context).size.width / 3,
        height: MediaQuery.of(context).size.height / 1.2,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 80,
              ),
              Text(
                "Banner Informativo",
                style: GoogleFonts.inter(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              if (_condomino != "") ...{
                _bannerImage(),
              },

              SizedBox(
                height: 20,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Condominios")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    Text("Carregando...");
                  } else {
                    List<DropdownMenuItem> condominiosItens = [];

                    for (int i = 0; i < snapshot.data.docs.length; i++) {
                      DocumentSnapshot snap = snapshot.data.docs[i];
                      condominiosItens.add(DropdownMenuItem(
                        child: Text(
                          snap.get("nome"),
                        ),
                        value: "${snap.get("nome")}",
                      ));
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        DropdownButton(
                          items: condominiosItens,
                          onChanged: (condominiosValue) {
                            setState(() {
                              condominioSelecionado = condominiosValue;
                              _condomino = condominioSelecionado;
                            });
                          },
                          value: condominioSelecionado,
                          hint: Text(
                            "Selecione o Condominio",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    );
                  }
                  return Container();
                },
              ),
              SizedBox(
                height: 20,
              ),
              // ignore: deprecated_member_use
              RaisedButton(
                child: Text(
                  "ENVIAR",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                color: Color(0xFF1E1C3F),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                padding:
                    EdgeInsets.only(left: 32, right: 32, top: 16, bottom: 16),
                onPressed: () {
                  _postBanner();
                },
              )
            ],
          ),
        ));
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
                    vertical: 30.0, horizontal: 60.0),
                child: _rigthSidePage(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
