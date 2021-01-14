import 'package:interport_app/app/modules/abertura_chamado/abertura_chamado_module.dart';
import 'package:interport_app/app/modules/abertura_chamado/chamados_em_aberto_page.dart';
import 'package:interport_app/app/modules/abertura_chamado/chamados_finalizados_page.dart';
import 'package:interport_app/app/modules/admin/admin_module.dart';
import 'package:interport_app/app/modules/banner/banner_module.dart';
import 'package:interport_app/app/modules/cad_condominios/cad_condominios_module.dart';
import 'package:interport_app/app/modules/cad_usuarios/cad_usuarios_module.dart';
import 'package:interport_app/app/modules/cameras/cameras_module.dart';
import 'package:interport_app/app/modules/chat/chat_module.dart';
import 'package:interport_app/app/modules/comunicados/comunicados_module.dart';
import 'package:interport_app/app/modules/eventos/eventos_module.dart';
import 'package:interport_app/app/modules/eventos/eventos_solicitados_page.dart';
import 'package:interport_app/app/modules/home/home_module.dart';
import 'package:interport_app/app/modules/livro_ocorrencia/livro_ocorrencia_module.dart';
import 'package:interport_app/app/modules/login/login_module.dart';
import 'package:interport_app/app/modules/loja/loja_cad_produtos_page.dart';
import 'package:interport_app/app/modules/loja/loja_module.dart';
import 'package:interport_app/app/modules/panico/panico_module.dart';
import 'package:interport_app/app/modules/politicas_da_empresa/politicas_da_empresa_module.dart';
import 'package:interport_app/app/modules/splash_screen/splash_screen_module.dart';
import 'package:interport_app/app/modules/start/start_module.dart';
import 'package:interport_app/app/modules/visitas/visitas_module.dart';
import 'app_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'package:interport_app/app/app_widget.dart';

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [
        $AppController,
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, module: SplashScreenModule()),
        ModularRouter('/start', module: StartModule()),
        ModularRouter('/login', module: LoginModule()),
        ModularRouter('/home', module: HomeModule()),
        ModularRouter('/admin', module: AdminModule()),
        ModularRouter('/chamado', module: AberturaChamadoModule()),
        ModularRouter('/chamados_em_aberto',
            child: (_, args) => ChamadosEmAbertoPage()),
        ModularRouter('/chamados_finalizados',
            child: (_, args) => ChamadosFinalizadosPage()),
        ModularRouter('/banner', module: BannerModule()),
        ModularRouter('/cad_condominio', module: CadCondominiosModule()),
        ModularRouter('/cad_usuarios', module: CadUsuariosModule()),
        ModularRouter('/cameras', module: CamerasModule()),
        ModularRouter('/chat', module: ChatModule()),
        ModularRouter('/comunicados', module: ComunicadosModule()),
        ModularRouter('/eventos', module: EventosModule()),
        ModularRouter('/ocorrencia', module: LivroOcorrenciaModule()),
        ModularRouter('/panico', module: PanicoModule()),
        ModularRouter('/visitas', module: VisitasModule()),
        ModularRouter('/loja', module: LojaModule()),
        ModularRouter('/politicas', module: PoliticasDaEmpresaModule()),
        ModularRouter('/eventos_solicitados',
            child: (_, args) => EventosSolicitadosPage()),
        ModularRouter('/cad_produtos',
            child: (_, args) => CadastroProdutosPage()),
      ];

  @override
  Widget get bootstrap => AppWidget();

  static Inject get to => Inject<AppModule>.of();
}
