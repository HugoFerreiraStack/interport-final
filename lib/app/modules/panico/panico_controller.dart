import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'panico_controller.g.dart';

@Injectable()
class PanicoController = _PanicoControllerBase with _$PanicoController;

abstract class _PanicoControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
