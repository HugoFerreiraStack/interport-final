import 'politicas_da_empresa_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'politicas_da_empresa_page.dart';

class PoliticasDaEmpresaModule extends ChildModule {
  @override
  List<Bind> get binds => [
        $PoliticasDaEmpresaController,
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute,
            child: (_, args) => PoliticasDaEmpresaPage()),
      ];

  static Inject get to => Inject<PoliticasDaEmpresaModule>.of();
}
