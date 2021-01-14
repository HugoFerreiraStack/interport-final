import 'package:flutter/src/widgets/framework.dart';

import 'chat_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'chat_page.dart';

class ChatModule extends WidgetModule {
  @override
  List<Bind> get binds => [
        $ChatController,
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => ChatPage()),
      ];

  static Inject get to => Inject<ChatModule>.of();

  @override
  // TODO: implement view
  Widget get view => ChatPage();
}
