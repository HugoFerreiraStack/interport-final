import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'cad_usuarios_controller.g.dart';

@Injectable()
class CadUsuariosController = _CadUsuariosControllerBase
    with _$CadUsuariosController;

abstract class _CadUsuariosControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
