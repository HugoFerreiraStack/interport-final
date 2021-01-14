import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_ink_well/image_ink_well.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interport_app/app/shared/model/produto.dart';

class CadastroProdutosPage extends StatefulWidget {
  @override
  _CadastroProdutosPageState createState() => _CadastroProdutosPageState();
}

class _CadastroProdutosPageState extends State<CadastroProdutosPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _controllerCodigoProduto = TextEditingController();
  TextEditingController _controllerNomeProduto = TextEditingController();
  TextEditingController _controllerPrecoProduto = TextEditingController();
  TextEditingController _controllerDescricaoProduto = TextEditingController();
  TextEditingController _controllerQuantidadeEmEstoque =
      TextEditingController();
  File _image;
  final picker = ImagePicker();
  final ImagePicker _picker = ImagePicker();
  String _id;
  String _urlImage = "";
  String _codigoProduto;
  String _nomeProduto;
  String _precoProduto;
  String _descricaoProduto;
  String _quantidadeEmEstoque;
  Produto _produto;

  _openGalery(BuildContext context) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _uploadImage();
      } else {
        print('No image selected.');
      }
    });

    Navigator.of(context).pop();
  }

  _uploadImage() async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("Produtos")
        .child(_produto.id)
        .child('/' + _produto.id + '.jpg');

    final UploadTask task = ref.putFile(_image);
    firebase_storage.TaskSnapshot taskSnapshot = await task;

    _urlImage = await taskSnapshot.ref.getDownloadURL();

    print(_urlImage);
  }

  _atualizarUrl() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("Produtos").doc(_produto.id).update({"url": _urlImage});
  }

  _validarCampos() {
    _id = _produto.id;
    _codigoProduto = _controllerCodigoProduto.text;
    _nomeProduto = _controllerNomeProduto.text;
    _precoProduto = _controllerPrecoProduto.text;
    _descricaoProduto = _controllerDescricaoProduto.text;
    _quantidadeEmEstoque = _controllerQuantidadeEmEstoque.text;

    Produto produto = Produto();
    produto.id = _id;
    produto.codigo = _codigoProduto;
    produto.nome = _nomeProduto;
    produto.preco = _precoProduto;
    produto.descricao = _descricaoProduto;
    produto.quantidade = _quantidadeEmEstoque;
    produto.url = _urlImage;
    _cadastrarProduto();
  }

  _cadastrarProduto() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("Produtos").doc(_produto.id).set(_produto.toMap());
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
        height: 150,
        image: FileImage(_image),
        onPressed: () {
          _showChoiceDialog(context);
        },
      );
    }
  }

  @override
  void initState() {
    _produto = Produto.gerarID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro de Produtos"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Selecione uma Imagem",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _bannerImage(),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: _controllerCodigoProduto,
              onChanged: (value) => _codigoProduto = value,
              onSaved: (cod) {
                _codigoProduto = cod;
                _produto.codigo = _controllerCodigoProduto.text;
                print(_produto.codigo);
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
                    Icons.code,
                    color: Color(0xFF1E1C3F),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6)),
                  hintText: "Digite o Codigo do Produto",
                  labelText: "Código"),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _controllerNomeProduto,
              onChanged: (value) => _nomeProduto = value,
              onSaved: (nome) {
                _nomeProduto = nome;
                _produto.nome = _controllerNomeProduto.text;
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
                    Icons.title,
                    color: Color(0xFF1E1C3F),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6)),
                  hintText: "Digite o Nome do Produto",
                  labelText: "Nome"),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _controllerPrecoProduto,
              onChanged: (value) => _precoProduto = value,
              onSaved: (preco) {
                _precoProduto = preco;
                _produto.preco = _controllerPrecoProduto.text;
              },
              validator: (valor) {
                if (valor.isEmpty) {
                  return "Este campo é obrigatorio";
                }
                return null;
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.attach_money,
                    color: Color(0xFF1E1C3F),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6)),
                  hintText: "Digite o Preço do Produto",
                  labelText: "Preço"),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _controllerDescricaoProduto,
              onChanged: (value) => _descricaoProduto = value,
              onSaved: (descricao) {
                _descricaoProduto = descricao;
                _produto.descricao = _controllerDescricaoProduto.text;
              },
              validator: (valor) {
                if (valor.isEmpty) {
                  return "Este campo é obrigatorio";
                }
                return null;
              },
              keyboardType: TextInputType.text,
              maxLines: 3,
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.description,
                    color: Color(0xFF1E1C3F),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6)),
                  hintText: "Digite a Descrição do Produto",
                  labelText: "Descrição"),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _controllerQuantidadeEmEstoque,
              onChanged: (value) => _quantidadeEmEstoque = value,
              onSaved: (qtd) {
                _quantidadeEmEstoque = qtd;
                _produto.quantidade = _controllerQuantidadeEmEstoque.text;
              },
              validator: (valor) {
                if (valor.isEmpty) {
                  return "Este campo é obrigatorio";
                }
                return null;
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.list,
                    color: Color(0xFF1E1C3F),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6)),
                  hintText: "Digite a Quantidade em Estoque",
                  labelText: "Quantidade"),
            ),
            SizedBox(
              height: 10,
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
                if (_formKey.currentState.validate()) {
                  setState(() {
                    _id = _produto.id;
                    _codigoProduto = _controllerCodigoProduto.text;
                    _nomeProduto = _controllerNomeProduto.text;
                    _precoProduto = _controllerPrecoProduto.text;
                    _descricaoProduto = _controllerDescricaoProduto.text;
                    _quantidadeEmEstoque = _controllerQuantidadeEmEstoque.text;
                    _formKey.currentState.save();

                    _validarCampos();
                    _atualizarUrl();
                    _formKey.currentState.reset();
                  });
                  Modular.to.pop();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
