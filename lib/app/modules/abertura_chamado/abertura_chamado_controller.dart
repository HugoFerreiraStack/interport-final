import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'abertura_chamado_controller.g.dart';

@Injectable()
class AberturaChamadoController = _AberturaChamadoControllerBase
    with _$AberturaChamadoController;

abstract class _AberturaChamadoControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
