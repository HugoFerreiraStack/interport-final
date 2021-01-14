import 'package:flutter/src/widgets/framework.dart';

import 'abertura_chamado_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'abertura_chamado_page.dart';

class AberturaChamadoModule extends WidgetModule {
  @override
  List<Bind> get binds => [
        $AberturaChamadoController,
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute,
            child: (_, args) => AberturaChamadoPage()),
      ];

  static Inject get to => Inject<AberturaChamadoModule>.of();

  @override
  // TODO: implement view
  Widget get view => AberturaChamadoPage();
}
