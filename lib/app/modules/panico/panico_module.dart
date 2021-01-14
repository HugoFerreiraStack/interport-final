import 'package:flutter/src/widgets/framework.dart';

import 'panico_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'panico_page.dart';

class PanicoModule extends WidgetModule {
  @override
  List<Bind> get binds => [
        $PanicoController,
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => PanicoPage()),
      ];

  static Inject get to => Inject<PanicoModule>.of();

  @override
  // TODO: implement view
  Widget get view => PanicoPage();
}
