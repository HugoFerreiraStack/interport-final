import 'package:card_settings/widgets/card_settings_panel.dart';
import 'package:card_settings/widgets/card_settings_widget.dart';
import 'package:card_settings/widgets/information_fields/card_settings_header.dart';
import 'package:card_settings/widgets/text_fields/card_settings_paragraph.dart';
import 'package:card_settings/widgets/text_fields/card_settings_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interport_app/app/shared/nav_bar.dart';
import 'package:intl/intl.dart';
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
  FirebaseFirestore db = FirebaseFirestore.instance;
  var condominioSelecionado;
  DateFormat formatter = DateFormat('dd/MM/yyyy');

  Widget _body() {
    return Container(
        width: MediaQuery.of(context).size.width / 2,
        height: MediaQuery.of(context).size.height,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Livro de Ocorrencias",
                style: GoogleFonts.inter(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(
                height: 30,
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
                  return Container();
                },
              ),
              SizedBox(
                height: 10,
              ),
              StreamBuilder(
                  stream: db
                      .collection("Ocorrencias")
                      .where("condominioNome",
                          isEqualTo: condominioSelecionado.toString())
                      .snapshots(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return CircularProgressIndicator();
                        break;
                      case ConnectionState.active:
                      case ConnectionState.done:
                        QuerySnapshot querySnapshot = snapshot.data;
                        if (querySnapshot.docs.length == 0) {
                          return Container(
                            padding: EdgeInsets.all(25),
                            child: Text(
                              "Nenhuma ocorrencia Encontrada",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          );
                        }
                        return Expanded(
                          flex: 2,
                          child: ListView.separated(
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data.docs.length,
                            padding: EdgeInsets.all(5),
                            itemBuilder: (context, i) {
                              return new CardSettings(
                                cardElevation: 2,
                                children: <CardSettingsSection>[
                                  CardSettingsSection(
                                    header: CardSettingsHeader(
                                      color: Colors.tealAccent,
                                      showMaterialonIOS: true,
                                      label: snapshot.data.docs[i]
                                          .data()['titulo'],
                                    ),
                                    children: <CardSettingsWidget>[
                                      CardSettingsText(
                                        contentAlign: TextAlign.end,
                                        label: "Autor:",
                                        initialValue: snapshot.data.docs[i]
                                            .data()['nomeUsuario'],
                                      ),
                                      CardSettingsText(
                                        contentAlign: TextAlign.end,
                                        label: "Apartamento:",
                                        initialValue: snapshot.data.docs[i]
                                            .data()['apartamento'],
                                      ),
                                      CardSettingsText(
                                        contentAlign: TextAlign.end,
                                        label: "Bloco:",
                                        initialValue: snapshot.data.docs[i]
                                            .data()['bloco'],
                                      ),
                                      CardSettingsText(
                                        contentAlign: TextAlign.end,
                                        label: "Descrição:",
                                        initialValue: snapshot.data.docs[i]
                                            .data()['descricao'],
                                      ),
                                      CardSettingsText(
                                        contentAlign: TextAlign.end,
                                        label: "Data da Ocorrencia:",
                                        initialValue: formatter.format(snapshot
                                            .data.docs[i]
                                            .data()['data']
                                            .toDate()),
                                      ),
                                      CardSettingsText(
                                        contentAlign: TextAlign.end,
                                        label: "Telefone:",
                                        initialValue: snapshot.data.docs[i]
                                            .data()['telefoneUsuario']
                                            .toString(),
                                      ),
                                    ],
                                  )
                                ],
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) => Divider(),
                          ),
                        );
                    }
                    return Container();
                  }),
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
                child: _body(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
