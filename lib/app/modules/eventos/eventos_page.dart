import 'package:card_settings/card_settings.dart';
import 'package:card_settings/widgets/card_settings_panel.dart';
import 'package:card_settings/widgets/card_settings_widget.dart';
import 'package:card_settings/widgets/information_fields/card_settings_header.dart';
import 'package:card_settings/widgets/text_fields/card_settings_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interport_app/app/shared/nav_bar.dart';
import 'eventos_controller.dart';

class EventosPage extends StatefulWidget {
  final String title;
  const EventosPage({Key key, this.title = "Eventos"}) : super(key: key);

  @override
  _EventosPageState createState() => _EventosPageState();
}

class _EventosPageState extends ModularState<EventosPage, EventosController> {
  //use 'controller' variable to access controller
  FirebaseFirestore db = FirebaseFirestore.instance;
  var condominioSelecionado;

  @override
  void initState() {
    super.initState();
  }

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
                "Eventos",
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
                      .collection("Eventos")
                      .where("condominio",
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
                              "Nenhum Evento Encontrado",
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
                                          .data()['condominio'],
                                    ),
                                    children: <CardSettingsWidget>[
                                      CardSettingsText(
                                        contentAlign: TextAlign.end,
                                        label: "Nome:",
                                        initialValue: snapshot.data.docs[i]
                                            .data()['moradorResponsavel'],
                                      ),
                                      CardSettingsText(
                                        contentAlign: TextAlign.end,
                                        label: "Titulo:",
                                        initialValue: snapshot.data.docs[i]
                                            .data()['nomeEvento'],
                                      ),
                                      CardSettingsText(
                                        contentAlign: TextAlign.end,
                                        label: "Data:",
                                        initialValue: snapshot.data.docs[i]
                                            .data()['data'],
                                      ),
                                      CardSettingsText(
                                        contentAlign: TextAlign.end,
                                        label: "Espaço:",
                                        initialValue: snapshot.data.docs[i]
                                            .data()['espaco'],
                                      ),
                                      CardSettingsText(
                                        contentAlign: TextAlign.end,
                                        label: "Hora inicial:",
                                        initialValue: snapshot.data.docs[i]
                                            .data()['horaInicial'],
                                      ),
                                      CardSettingsText(
                                        contentAlign: TextAlign.end,
                                        label: "Termino:",
                                        initialValue: snapshot.data.docs[i]
                                            .data()['horaFinal'],
                                      ),
                                      CardSettingsParagraph(
                                        initialValue: snapshot.data.docs[i]
                                            .data()['descricao'],
                                        label: "Descrição:",
                                        numberOfLines: 2,
                                      ),
                                      CardSettingsSwitch(
                                        contentAlign: TextAlign.end,
                                        label: "Status",
                                        falseLabel: "Em Análise",
                                        trueLabel: "Confirmada",
                                        initialValue: snapshot.data.docs[i]
                                            .data()['status'],
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
