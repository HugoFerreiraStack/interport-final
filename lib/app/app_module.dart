import 'package:interport_app/app/modules/abertura_chamado/abertura_chamado_controller.dart';
import 'package:interport_app/app/modules/abertura_chamado/abertura_chamado_module.dart';
import 'package:interport_app/app/modules/abertura_chamado/chamados_em_aberto_page.dart';
import 'package:interport_app/app/modules/abertura_chamado/chamados_finalizados_page.dart';
import 'package:interport_app/app/modules/admin/admin_controller.dart';
import 'package:interport_app/app/modules/admin/admin_module.dart';
import 'package:interport_app/app/modules/banner/banner_controller.dart';
import 'package:interport_app/app/modules/banner/banner_module.dart';
import 'package:interport_app/app/modules/cad_condominios/cad_condominios_controller.dart';
import 'package:interport_app/app/modules/cad_condominios/cad_condominios_module.dart';
import 'package:interport_app/app/modules/cad_usuarios/cad_usuarios_controller.dart';
import 'package:interport_app/app/modules/cad_usuarios/cad_usuarios_module.dart';
import 'package:interport_app/app/modules/comunicados/comunicados_controller.dart';
import 'package:interport_app/app/modules/comunicados/comunicados_module.dart';
import 'package:interport_app/app/modules/eventos/eventos_controller.dart';
import 'package:interport_app/app/modules/eventos/eventos_module.dart';
import 'package:interport_app/app/modules/home/home_controller.dart';
import 'package:interport_app/app/modules/home/home_module.dart';
import 'package:interport_app/app/modules/livro_ocorrencia/livro_ocorrencia_controller.dart';
import 'package:interport_app/app/modules/livro_ocorrencia/livro_ocorrencia_module.dart';
import 'package:interport_app/app/modules/login/login_controller.dart';
import 'package:interport_app/app/modules/login/login_module.dart';
import 'package:interport_app/app/modules/panico/panico_controller.dart';
import 'package:interport_app/app/modules/panico/panico_module.dart';
import 'package:interport_app/app/modules/politicas_da_empresa/politicas_da_empresa_controller.dart';
import 'package:interport_app/app/modules/politicas_da_empresa/politicas_da_empresa_module.dart';
import 'package:interport_app/app/modules/visitas/visitas_controller.dart';
import 'package:interport_app/app/modules/visitas/visitas_module.dart';
import 'app_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'package:interport_app/app/app_widget.dart';

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [
        $AppController,
        Bind((i) => AberturaChamadoController()),
        Bind((i) => AdminController()),
        Bind((i) => BannerController()),
        Bind((i) => CadCondominiosController()),
        Bind((i) => CadUsuariosController()),
        Bind((i) => ComunicadosController()),
        Bind((i) => EventosController()),
        Bind((i) => HomeController()),
        Bind((i) => LivroOcorrenciaController()),
        Bind((i) => LoginController()),
        Bind((i) => PanicoController()),
        Bind((i) => PoliticasDaEmpresaController()),
        Bind((i) => VisitasController()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, module: LoginModule()),
        ModularRouter('/login', module: LoginModule()),
        ModularRouter('/home', module: HomeModule()),
        ModularRouter('/admin', module: AdminModule()),
        ModularRouter('/chamado', module: AberturaChamadoModule()),
        ModularRouter('/banner', module: BannerModule()),
        ModularRouter('/condominio', module: CadCondominiosModule()),
        ModularRouter('/usuarios', module: CadUsuariosModule()),
        ModularRouter('/comunicados', module: ComunicadosModule()),
        ModularRouter('/eventos', module: EventosModule()),
        ModularRouter('/ocorrencia', module: LivroOcorrenciaModule()),
        ModularRouter('/panico', module: PanicoModule()),
        ModularRouter('/visitas', module: VisitasModule()),
        ModularRouter('/politicas', module: PoliticasDaEmpresaModule()),
      ];

  @override
  Widget get bootstrap => AppWidget();

  static Inject get to => Inject<AppModule>.of();
}
