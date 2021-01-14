import 'comunicados_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'comunicados_page.dart';

class ComunicadosModule extends ChildModule {
  @override
  List<Bind> get binds => [
        $ComunicadosController,
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute,
            child: (_, args) => ComunicadosPage()),
      ];

  static Inject get to => Inject<ComunicadosModule>.of();
}
