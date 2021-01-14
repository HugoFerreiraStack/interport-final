import 'livro_ocorrencia_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'livro_ocorrencia_page.dart';

class LivroOcorrenciaModule extends ChildModule {
  @override
  List<Bind> get binds => [
        $LivroOcorrenciaController,
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute,
            child: (_, args) => LivroOcorrenciaPage()),
      ];

  static Inject get to => Inject<LivroOcorrenciaModule>.of();
}
