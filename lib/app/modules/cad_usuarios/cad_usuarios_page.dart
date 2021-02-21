import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_ink_well/image_ink_well.dart';
import 'package:interport_app/app/shared/model/Usuario.dart';
import 'cad_usuarios_controller.dart';
import 'package:firebase/firebase.dart' as fb;
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
  File imageFile;
  fb.UploadTask _uploadTask;
  final formKey = GlobalKey<FormState>();
  var tipoUsuarioSelecionado;
  var condominioSelecionado;
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  final _controllerFone = MaskedTextController(mask: '(00)00000-0000');
  TextEditingController _controllerBloco = TextEditingController();
  TextEditingController _controllerApt = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _id;
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
  Usuario _usuario;

  List<String> _tipoUsuario = <String>[
    "Admin",
    "Morador",
    "Sindico",
    "Funcionario"
  ];

  _validarCampos() {
    if (_email.isNotEmpty && _email.contains("@")) {
      if (_senha.isNotEmpty && _senha.length > 5) {
        Usuario usuario = Usuario();
        usuario.id = _usuario.id;
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
        _controllerNome.clear();
        _controllerEmail.clear();
        _controllerFone.clear();
        _controllerSenha.clear();
        _controllerApt.clear();
        _controllerBloco.clear();
      } else {
        setState(() {});
      }
    } else {
      setState(() {});
    }
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
          .child(_tipoUsuarioFinal)
          .child(_id)
          .child('/profile.png')
          .put(imageFile);
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      printUrl();
    });
  }

  printUrl() async {
    fb.StorageReference ref = fb
        .storage()
        .refFromURL('gs://interport-02.appspot.com/')
        .child(_tipoUsuarioFinal)
        .child(_id)
        .child('/profile.png');
    String url = (await ref.getDownloadURL()).toString();
    setState(() {
      _urlImage = url;
    });
  }

  Widget _avatarUser() {
    if (_urlImage == null) {
      return ImageInkWell(
        height: 100,
        width: 100,
        onPressed: () {
          uploadImage();
        },
        image: AssetImage("images/avatar.png"),
      );
    } else {
      return CircleImageInkWell(
        image: NetworkImage(_urlImage),
        onPressed: () {
          uploadImage();
        },
        size: 100,
      );
    }
  }

  @override
  void initState() {
    _usuario = Usuario.gerarID();
    setState(() {
      _id = _usuario.id;
    });
    super.initState();
  }

  Widget _bodySelect() {
    if (_tipoUsuarioFinal == "Admin") {
      return _cadAdmin();
    } else if (_tipoUsuarioFinal == "Morador") {
      return _cadMorador();
    } else if (_tipoUsuarioFinal == "Sindico") {
      return _cadSindico();
    } else if (_tipoUsuarioFinal == "Funcionario") {
      return _cadFuncionarios();
    } else {
      return Center(
        child: Column(
          children: <Widget>[
            Text(
              "Selecione um tipo de Usuario para cadastrar",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            )
          ],
        ),
      );
    }
  }

  Widget _cadFuncionarios() {
    return Container(
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            _avatarUser(),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
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
                ),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: TextFormField(
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
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
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
                ),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: TextFormField(
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
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Condominios")
                  .snapshots(),
              // ignore: missing_return
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
                return Container();
              },
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 200, right: 200),
              child: RaisedButton(
                child: Text(
                  "CADASTRAR",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                color: Color(0xFF1E1C3F),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                onPressed: () async {
                  if (formKey.currentState.validate()) {
                    setState(() {
                      _nome = _controllerNome.text;
                      _email = _controllerEmail.text;
                      _telefone = _controllerFone.text;
                      _senha = _controllerSenha.text;
                      _tipoUsuarioFinal = tipoUsuarioSelecionado;
                      _condomino = condominioSelecionado;
                      _bloco = "Nao possui";
                      _apt = "Nao possui";
                      formKey.currentState.save();
                      _validarCampos();
                    });
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _cadSindico() {
    return Container(
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            _avatarUser(),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
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
                ),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: TextFormField(
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
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
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
                ),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: TextFormField(
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
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Condominios")
                  .snapshots(),
              // ignore: missing_return
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
                return Container();
              },
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 200, right: 200),
              child: RaisedButton(
                child: Text(
                  "CADASTRAR",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                color: Color(0xFF1E1C3F),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                onPressed: () async {
                  if (formKey.currentState.validate()) {
                    setState(() {
                      _nome = _controllerNome.text;
                      _email = _controllerEmail.text;
                      _telefone = _controllerFone.text;
                      _senha = _controllerSenha.text;
                      _tipoUsuarioFinal = tipoUsuarioSelecionado;
                      _condomino = condominioSelecionado;
                      _bloco = "Nao possui";
                      _apt = "Nao possui";
                      formKey.currentState.save();

                      _validarCampos();
                    });
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _cadAdmin() {
    return Container(
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            _avatarUser(),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
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
                ),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: TextFormField(
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
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
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
                ),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: TextFormField(
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
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 200, right: 200),
              child: RaisedButton(
                child: Text(
                  "CADASTRAR",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                color: Color(0xFF1E1C3F),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                onPressed: () async {
                  if (formKey.currentState.validate()) {
                    setState(() {
                      _nome = _controllerNome.text;
                      _email = _controllerEmail.text;
                      _telefone = _controllerFone.text;
                      _senha = _controllerSenha.text;
                      _tipoUsuarioFinal = tipoUsuarioSelecionado;
                      _condomino = "Nao Possui";
                      _bloco = "Nao possui";
                      _apt = "Nao possui";
                      formKey.currentState.save();
                      _validarCampos();
                    });
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _cadMorador() {
    return Container(
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            _avatarUser(),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
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
                ),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: TextFormField(
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
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
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
                ),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: TextFormField(
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
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
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
                ),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: TextFormField(
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
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Condominios")
                  .snapshots(),
              // ignore: missing_return
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
                return Container();
              },
            ),
            SizedBox(
              height: 20,
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
                  activeColor: Color(0xFF1E1C3F),
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
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 200, right: 200),
              child: RaisedButton(
                child: Text(
                  "CADASTRAR",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                color: Color(0xFF1E1C3F),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                onPressed: () async {
                  if (formKey.currentState.validate()) {
                    setState(() {
                      _nome = _controllerNome.text;
                      _email = _controllerEmail.text;
                      _telefone = _controllerFone.text;
                      _senha = _controllerSenha.text;
                      _tipoUsuarioFinal = tipoUsuarioSelecionado;

                      _bloco = _controllerBloco.text;
                      _apt = _controllerApt.text;
                      if (_condomino == null) {
                        _condomino = "";
                      } else {
                        _condomino = condominioSelecionado.toString();
                      }
                      formKey.currentState.save();

                      _validarCampos();
                    });
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Modular.to.pop(context);
            },
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF1E1C3F),
          title: Text(widget.title),
        ),
        body: Form(
          key: formKey,
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 180,
                    height: 200,
                    child: Image.asset(
                      "images/logo.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DropdownButton(
                        elevation: 12,
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
                            _tipoUsuarioFinal =
                                tipoUsuarioSelecionado.toString();
                            print(_tipoUsuarioFinal);
                            print(_id);
                          });
                        },
                        value: tipoUsuarioSelecionado,
                        hint: Text(
                          "Selecione o Tipo de Usuario",
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _bodySelect(),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
