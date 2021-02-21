import 'package:flutter/src/widgets/framework.dart';

import 'banner_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'banner_page.dart';

class BannerModule extends WidgetModule {
  @override
  List<Bind> get binds => [
        $BannerController,
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => BannerPage()),
      ];

  static Inject get to => Inject<BannerModule>.of();

  @override
  // TODO: implement view
  Widget get view => BannerPage();
}
