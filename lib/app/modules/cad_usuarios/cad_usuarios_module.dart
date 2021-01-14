import 'cad_usuarios_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'cad_usuarios_page.dart';

class CadUsuariosModule extends ChildModule {
  @override
  List<Bind> get binds => [
        $CadUsuariosController,
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute,
            child: (_, args) => CadUsuariosPage()),
      ];

  static Inject get to => Inject<CadUsuariosModule>.of();
}
