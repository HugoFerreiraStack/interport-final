import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'cad_condominios_controller.g.dart';

@Injectable()
class CadCondominiosController = _CadCondominiosControllerBase
    with _$CadCondominiosController;

abstract class _CadCondominiosControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
