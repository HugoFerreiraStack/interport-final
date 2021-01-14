import 'package:flutter/src/widgets/framework.dart';

import 'cameras_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'cameras_page.dart';

class CamerasModule extends WidgetModule {
  @override
  List<Bind> get binds => [
        $CamerasController,
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => CamerasPage()),
      ];

  static Inject get to => Inject<CamerasModule>.of();

  @override
  // TODO: implement view
  Widget get view => CamerasPage();
}
