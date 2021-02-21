import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interport_app/app/shared/model/chamados.dart';
import 'package:path_provider/path_provider.dart';
import 'abertura_chamado_controller.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AberturaChamadoPage extends StatefulWidget {
  final String title;
  const AberturaChamadoPage({Key key, this.title = "AberturaChamado"})
      : super(key: key);

  @override
  _AberturaChamadoPageState createState() => _AberturaChamadoPageState();
}

class _AberturaChamadoPageState
    extends ModularState<AberturaChamadoPage, AberturaChamadoController> {
  //use 'controller' variable to access controller
  FirebaseFirestore db = FirebaseFirestore.instance;
  final _controllerFone = MaskedTextController(mask: '(00)00000-0000');
  TextEditingController _controllerCodigoProduto = TextEditingController();
  TextEditingController _controllerOcorrencia = TextEditingController();
  TextEditingController _controllerMemo = TextEditingController();
  TextEditingController _controllerContato = TextEditingController();
  TextEditingController _controllerNumeroChamado = TextEditingController();
  TextEditingController _controllerCodigoCliente = TextEditingController();
  TextEditingController _controllerLojaCliente = TextEditingController();

  String _atendente = "00000000000031";
  String _filial = "10501105";
  String _telefone;
  String _codigoProduto;
  String _idUnico;
  String _ocorrencia;
  String _memo;
  String _contato;
  int _classificacao = 1;
  int _numeroChamado;
  int _codigoCliente;
  int _lojaCliente;
  String _dataEmissao;
  Timestamp _horaInicio;
  Timestamp _horaFim;
  File jsonFile;
  String _url;
  String fileName = 'myJsonFile.json';
  bool _fileExists = false;
  File _filePath;

  // First initialization of _json (if there is no json in the file)
  Map<String, dynamic> _json = {};
  String _jsonString;
  Map<String, dynamic> fileContent;
  static final now = DateTime.now();
  final formKey = GlobalKey<FormState>();
  var condominioSelecionado;

  _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = await auth.currentUser;

    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot =
        await db.collection("Usuarios").doc(user.uid).get();
    String nome = snapshot.get("nome");
    setState(() {
      //_atendente = nome;
    });
  }

  _gerarId() {
    CollectionReference chamados = db.collection("Chamados");
    setState(() {
      _idUnico = chamados.doc().id;
    });
  }

  _gerarChamado() async {
    Chamados chamado = Chamados(
      atendente: _atendente,
      classificacao: _classificacao,
      codigoCliente: _codigoCliente,
      codigoProduto: _codigoProduto,
      contato: _contato,
      dataEmissao: DateTime.now(),
      filial: _filial,
      horaFim: Timestamp.now(),
      horaInicio: Timestamp.now(),
      idUnico: _idUnico,
      lojaCliente: _lojaCliente,
      memo: _memo,
      numeroChamado: _numeroChamado,
      ocorrencia: _ocorrencia,
      telefone: _telefone,
    );

    db.collection('Chamados').doc(_idUnico).set(chamado.toJson());

    Directory directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();
    File file = await File("${directory.path}/chamado.json").create();
    String fileContent = json.encode({chamado.toJson()});
    return await file.writeAsString(fileContent);
  }

  _upload(File file) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("Chamados" + _filial)
        .child(_idUnico);
    final UploadTask task = ref.putFile(file);
    firebase_storage.TaskSnapshot taskSnapshot = await task;

    _url = await taskSnapshot.ref.getDownloadURL();
    print(_url);
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  @override
  void initState() {
    _verificarUsuarioLogado();
    _gerarId();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1E1C3F),
        title: Text("Abertuda de Chamado"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
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
                                _filial = condominioSelecionado.toString();
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
                  height: 30,
                ),
                TextFormField(
                  onChanged: (fone) {
                    _telefone = fone;
                    print(_telefone);
                  },
                  validator: (valor) {
                    if (valor.isEmpty) {
                      return "Este campo é obrigatorio";
                    }
                    return null;
                  },
                  controller: _controllerFone,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Color(0xFF1E1C3F),
                      ),
                      hintText: "Telefone",
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _controllerCodigoProduto,
                  onChanged: (codProd) {
                    _codigoProduto = codProd;
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
                        Icons.qr_code_sharp,
                        color: Color(0xFF1E1C3F),
                      ),
                      hintText: "Codigo do Produto",
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _controllerOcorrencia,
                  onChanged: (oco) {
                    _ocorrencia = oco;
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
                        Icons.table_chart,
                        color: Color(0xFF1E1C3F),
                      ),
                      hintText: "Ocorrencia",
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _controllerMemo,
                  onChanged: (memo) {
                    _memo = memo;
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
                        Icons.messenger,
                        color: Color(0xFF1E1C3F),
                      ),
                      hintText: "Memo",
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _controllerContato,
                  onChanged: (cont) {
                    _contato = cont;
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
                        Icons.contact_mail,
                        color: Color(0xFF1E1C3F),
                      ),
                      hintText: "Contato",
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Classificação",
                      style: GoogleFonts.titilliumWeb(fontSize: 25),
                    )
                  ],
                ),
                TextFormField(
                  controller: _controllerNumeroChamado,
                  onChanged: (numero) {
                    _numeroChamado = int.parse(numero);
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
                        Icons.format_list_numbered_outlined,
                        color: Color(0xFF1E1C3F),
                      ),
                      hintText: "Numero Chamado",
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _controllerCodigoCliente,
                  onChanged: (codClie) {
                    _codigoCliente = int.parse(codClie);
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
                        Icons.format_list_numbered_outlined,
                        color: Color(0xFF1E1C3F),
                      ),
                      hintText: "Codigo Cliente",
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _controllerLojaCliente,
                  onChanged: (lojClie) {
                    _lojaCliente = int.parse(lojClie);
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
                        Icons.format_list_numbered_outlined,
                        color: Color(0xFF1E1C3F),
                      ),
                      hintText: "Loja Cliente",
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Data de Emissão"),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  child: Text(
                    "ABRIR CHAMADO",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  color: Color(0xFF1E1C3F),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  padding:
                      EdgeInsets.only(left: 80, right: 80, top: 16, bottom: 16),
                  onPressed: () async {
                    _gerarChamado();

                    Modular.to.pop();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
