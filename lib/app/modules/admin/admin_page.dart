import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:multilevel_drawer/multilevel_drawer.dart';
import 'admin_controller.dart';

class AdminPage extends StatefulWidget {
  final String title;
  const AdminPage({Key key, this.title = "Admin"}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends ModularState<AdminPage, AdminController> {
  //use 'controller' variable to access controller

  Future<void> logout() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.signOut() as User;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        drawer: MultiLevelDrawer(
          backgroundColor: Colors.white,
          rippleColor: Colors.white,
          subMenuBackgroundColor: Colors.grey.shade100,
          divisionColor: Colors.grey,
          header: Container(
            height: size.height * 0.25,
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "images/logo.png",
                  width: 150,
                  height: 50,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Painel Admin",
                  style: TextStyle(fontSize: 15, color: Color(0xFF1E1C3F)),
                )
              ],
            )),
          ),
          children: [
            MLMenuItem(
                leading: Icon(Icons.person),
                trailing: Icon(Icons.arrow_right),
                content: Text(
                  "Usuarios",
                ),
                subMenuItems: [
                  MLSubmenu(
                      onClick: () {
                        Modular.to.pushNamed("cad_usuarios");
                      },
                      submenuContent: Text("Cadastrar Usuario")),
                  MLSubmenu(
                      onClick: () {}, submenuContent: Text("Editar Usuarios")),
                  MLSubmenu(
                      onClick: () {},
                      submenuContent: Text("Cadastrar Funcionario")),
                ],
                onClick: () {}),
            MLMenuItem(
              leading: Icon(Icons.add_location),
              trailing: Icon(Icons.arrow_right),
              content: Text("Cadastro de Condominios"),
              onClick: () {
                Modular.to.pushNamed("cad_condominio");
              },
            ),
            MLMenuItem(
              leading: Icon(Icons.notifications),
              content: Text("Banner Informativo"),
              onClick: () {
                Modular.to.pushNamed('banner');
              },
            ),
            MLMenuItem(
              leading: Icon(Icons.notifications),
              trailing: Icon(Icons.arrow_right),
              content: Text("Chamados"),
              onClick: () {},
              subMenuItems: [
                MLSubmenu(
                    onClick: () {
                      Modular.to.pushNamed('chamado');
                    },
                    submenuContent: Text("Abrir Chamado")),
                MLSubmenu(
                    onClick: () {
                      Modular.to.pushNamed('chamados_em_aberto');
                    },
                    submenuContent: Text("Chamados em Aberto")),
                MLSubmenu(
                    onClick: () {
                      Modular.to.pushNamed('chamados_finalizados');
                    },
                    submenuContent: Text("Chamados Finalizados")),
              ],
            ),
            MLMenuItem(
              leading: Icon(Icons.admin_panel_settings),
              trailing: Icon(Icons.arrow_right),
              content: Text("Eventos"),
              onClick: () {
                Modular.to.pushNamed("eventos_solicitados");
              },
            ),
            MLMenuItem(
                leading: Icon(Icons.speaker_notes),
                trailing: Icon(Icons.arrow_right),
                content: Text(
                  "Comunicados",
                ),
                onClick: () {
                  Modular.to.pushNamed("comunicados");
                }),
            MLMenuItem(
              leading: Icon(Icons.store),
              content: Text("Loja"),
              onClick: () {
                Modular.to.pushNamed('cad_produtos');
              },
            ),
          ],
        ),
        appBar: AppBar(
          backgroundColor: Color(0xFF1E1C3F),
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            "Interport Admin",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Container(
            child: Center(
          child: FloatingActionButton(
            child: Icon(Icons.exit_to_app),
            backgroundColor: Colors.red,
            onPressed: () {
              logout();
              Modular.to.pushReplacementNamed('/login');
            },
          ),
        )),
      ),
    );
  }
}
