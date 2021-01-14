import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_ink_well/image_ink_well.dart';
import 'package:image_picker/image_picker.dart';
import 'banner_controller.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class BannerPage extends StatefulWidget {
  final String title;
  const BannerPage({Key key, this.title = "Banner"}) : super(key: key);

  @override
  _BannerPageState createState() => _BannerPageState();
}

class _BannerPageState extends ModularState<BannerPage, BannerController> {
  //use 'controller' variable to access controller

  File _image;
  final picker = ImagePicker();
  final ImagePicker _picker = ImagePicker();
  var condominioSelecionado;
  String _condomino;
  String _urlImage;

  _openGalery(BuildContext context) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });

    Navigator.of(context).pop();
  }

  _uploadImage() async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child(_condomino)
        .child('/banner.jpg');

    final UploadTask task = ref.putFile(_image);
    _urlImage = await task.snapshot.ref.getDownloadURL();
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Selecionar imagem"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Galeria"),
                    onTap: () {
                      _openGalery(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _bannerImage() {
    if (_image == null) {
      return ImageInkWell(
        height: 100,
        width: 100,
        onPressed: () {
          _showChoiceDialog(context);
        },
        image: AssetImage("images/noimage.jpg"),
      );
    } else {
      return ImageInkWell(
        fit: BoxFit.contain,
        width: 250,
        height: 250,
        image: FileImage(_image),
        onPressed: () {
          _showChoiceDialog(context);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1E1C3F),
        title: Text(widget.title),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _bannerImage(),
            ],
          ),
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
                      hint: Text("Selecione o Condominio"),
                    ),
                  ],
                );
              }
            },
          ),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            child: Text(
              "ENVIAR",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            color: Color(0xFF1E1C3F),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            padding: EdgeInsets.only(left: 32, right: 32, top: 16, bottom: 16),
            onPressed: () async {
              if (_condomino != null) {
                _uploadImage();
              } else {
                return "Por Favor, selecione um condominio";
              }
            },
          )
        ],
      ),
    );
  }
}
