import 'package:flutter/src/widgets/framework.dart';

import 'visitas_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'visitas_page.dart';

class VisitasModule extends WidgetModule {
  @override
  List<Bind> get binds => [
        $VisitasController,
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => VisitasPage()),
      ];

  static Inject get to => Inject<VisitasModule>.of();

  @override
  // TODO: implement view
  Widget get view => VisitasPage();
}
