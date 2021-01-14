import 'package:flutter/src/widgets/framework.dart';

import 'eventos_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'eventos_page.dart';

class EventosModule extends WidgetModule {
  @override
  List<Bind> get binds => [
        $EventosController,
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => EventosPage()),
      ];

  static Inject get to => Inject<EventosModule>.of();

  @override
  // TODO: implement view
  Widget get view => EventosPage();
}
