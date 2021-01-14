import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'comunicados_controller.g.dart';

@Injectable()
class ComunicadosController = _ComunicadosControllerBase
    with _$ComunicadosController;

abstract class _ComunicadosControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
