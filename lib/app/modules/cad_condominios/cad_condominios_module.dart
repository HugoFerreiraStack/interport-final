import 'package:flutter/src/widgets/framework.dart';

import 'cad_condominios_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'cad_condominios_page.dart';

class CadCondominiosModule extends WidgetModule {
  @override
  List<Bind> get binds => [
        $CadCondominiosController,
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute,
            child: (_, args) => CadCondominiosPage()),
      ];

  static Inject get to => Inject<CadCondominiosModule>.of();

  @override
  // TODO: implement view
  Widget get view => CadCondominiosPage();
}
