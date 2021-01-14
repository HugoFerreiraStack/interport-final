import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_ink_well/image_ink_well.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interport_app/app/shared/model/Usuario.dart';
import 'cad_usuarios_controller.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CadUsuariosPage extends StatefulWidget {
  final String title;
  const CadUsuariosPage({Key key, this.title = "Cadastro de Usuarios"})
      : super(key: key);

  @override
  _CadUsuariosPageState createState() => _CadUsuariosPageState();
}

class _CadUsuariosPageState
    extends ModularState<CadUsuariosPage, CadUsuariosController> {
  //use 'controller' variable to access controller
  File _image;
  final picker = ImagePicker();
  final ImagePicker _picker = ImagePicker();
  final formKey = GlobalKey<FormState>();
  var tipoUsuarioSelecionado;
  var condominioSelecionado;
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerFone = TextEditingController();
  TextEditingController _controllerBloco = TextEditingController();
  TextEditingController _controllerApt = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();

  String _nome;
  String _email;
  String _bloco;
  String _apt;
  String _telefone;
  String _senha;
  String _urlImage;
  String _tipoUsuarioFinal;
  String _condomino;
  bool master = false;
  String firebaseUserData;

  List<String> _tipoUsuario = <String>[
    "Morador",
    "Sindico",
    "Admin",
    "Funcionario"
  ];

  _uploadImage() async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child(_condomino)
        .child(_nome)
        .child('/profile.png');

    final UploadTask task = ref.putFile(_image);
    _urlImage = await task.snapshot.ref.getDownloadURL();
  }

  _validarCampos() {
    _nome = _controllerNome.text;
    _email = _controllerEmail.text;
    _senha = _controllerSenha.text;
    _telefone = _controllerFone.text;
    _apt = _controllerApt.text;
    _bloco = _controllerBloco.text;
    _tipoUsuarioFinal = tipoUsuarioSelecionado.toString();
    _condomino = condominioSelecionado.toString();

    if (_email.isNotEmpty && _email.contains("@")) {
      if (_senha.isNotEmpty && _senha.length > 5) {
      } else {
        setState(() {});
      }
      Usuario usuario = Usuario();
      usuario.nome = _nome;
      usuario.email = _email;
      usuario.senha = _senha;
      usuario.telefone = _telefone;
      usuario.condominio = _condomino;
      usuario.bloco = _bloco;
      usuario.apartamento = _apt;
      usuario.tipoUsuario = _tipoUsuarioFinal;
      usuario.urlImage = _urlImage;
      usuario.master = master;

      _cadastrarUsuario(usuario);
    } else {
      setState(() {});
    }
  }

  _atualizarUrl() async {
    FirebaseFirestore db = await FirebaseFirestore.instance;
    db
        .collection("Usuarios")
        .doc(firebaseUserData)
        .update({"urlImage": _urlImage});
  }

  _cadastrarUsuario(Usuario usuario) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;

    auth
        .createUserWithEmailAndPassword(
            email: usuario.email, password: usuario.senha)
        .then((firebaseUser) {
      setState(() {
        FirebaseFirestore db = FirebaseFirestore.instance;
        db
            .collection("Usuarios")
            .doc(firebaseUser.user.uid)
            .set(usuario.toMap());

        firebaseUserData = firebaseUser.user.uid;
      });
    }).catchError((onError) {
      print(onError);
    });
  }

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

  _openCamera(BuildContext context) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });

    Navigator.of(context).pop();
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
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: () {
                      _openCamera(context);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget _avatarUser() {
    if (_image == null) {
      return ImageInkWell(
        height: 100,
        width: 100,
        onPressed: () {
          _showChoiceDialog(context);
        },
        image: AssetImage("images/avatar.png"),
      );
    } else {
      return CircleAvatar(
        backgroundImage: FileImage(_image),
        radius: 80,
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF1E1C3F),
          title: Text(widget.title),
        ),
        body: Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _avatarUser(),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                child: Text(
                  "SELECIONAR FOTO",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                color: Color(0xFF1E1C3F),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                onPressed: () async {
                  _showChoiceDialog(context);
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _controllerNome,
                onSaved: (nome) {
                  _nome = nome;
                  print(_nome);
                },
                validator: (valor) {
                  if (valor.isEmpty) {
                    return "Este campo é obrigatorio";
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person,
                      color: Color(0xFF1E1C3F),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6)),
                    hintText: "Digite o nome do usuario",
                    labelText: "Nome"),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _controllerEmail,
                onSaved: (email) {
                  _email = email;
                  print(_email);
                },
                validator: (valor) {
                  if (valor.isEmpty) {
                    return "Este campo é obrigatorio";
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.email,
                      color: Color(0xFF1E1C3F),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6)),
                    hintText: "Digite o e-mail do usuario",
                    labelText: "E-Mail"),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _controllerFone,
                onSaved: (fone) {
                  _telefone = fone;
                  print(_telefone);
                },
                validator: (valor) {
                  if (valor.isEmpty) {
                    return "Este campo é obrigatorio";
                  }
                  return null;
                },
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Color(0xFF1E1C3F),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6)),
                    hintText: "Digite o telefone do usuario",
                    labelText: "Telefone"),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _controllerSenha,
                onSaved: (senha) {
                  _senha = senha;
                  print(_senha);
                },
                validator: (valor) {
                  if (valor.isEmpty) {
                    return "Este campo é obrigatorio";
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Color(0xFF1E1C3F),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6)),
                    hintText: "Digite a senha do usuario",
                    labelText: "Senha"),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  DropdownButton(
                    items: _tipoUsuario
                        .map((value) => DropdownMenuItem(
                              child: Text(
                                value,
                              ),
                              value: value,
                            ))
                        .toList(),
                    onChanged: (_tipoUsuarioSelecionado) {
                      setState(() {
                        tipoUsuarioSelecionado = _tipoUsuarioSelecionado;
                      });
                    },
                    value: tipoUsuarioSelecionado,
                    hint: Text("Selecione o Tipo de Usuario"),
                  )
                ],
              ),
              SizedBox(
                height: 10,
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
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Usuario Master?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Checkbox(
                    onChanged: (bool value) {
                      setState(() {
                        master = value;
                      });
                    },
                    value: master,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _controllerBloco,
                onSaved: (bloco) {
                  _bloco = bloco;
                  print(_bloco);
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.home,
                      color: Color(0xFF1E1C3F),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6)),
                    hintText: "Digite o Bloco",
                    labelText: "Bloco"),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _controllerApt,
                onSaved: (apt) {
                  _apt = apt;
                  print(_apt);
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.home,
                      color: Color(0xFF1E1C3F),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6)),
                    hintText: "Digite o Apartamento do usuario",
                    labelText: "Apartamento"),
              ),
              SizedBox(
                height: 15,
              ),
              RaisedButton(
                child: Text(
                  "CADASTRAR",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                color: Color(0xFF1E1C3F),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                padding:
                    EdgeInsets.only(left: 32, right: 32, top: 16, bottom: 16),
                onPressed: () async {
                  if (formKey.currentState.validate()) {
                    setState(() {
                      _nome = _controllerNome.text;
                      _email = _controllerEmail.text;
                      _telefone = _controllerFone.text;
                      _senha = _controllerSenha.text;
                      _tipoUsuarioFinal = tipoUsuarioSelecionado;
                      _condomino = condominioSelecionado;
                      _bloco = _controllerBloco.text;
                      _apt = _controllerApt.text;
                      formKey.currentState.save();

                      _uploadImage();
                      _validarCampos();
                      _atualizarUrl();
                    });
                  }
                },
              )
            ],
          ),
        ));
  }
}
