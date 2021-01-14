import 'cad_condominios_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'cad_condominios_page.dart';

class CadCondominiosModule extends ChildModule {
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
}
