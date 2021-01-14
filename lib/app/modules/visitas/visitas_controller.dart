import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'visitas_controller.g.dart';

@Injectable()
class VisitasController = _VisitasControllerBase with _$VisitasController;

abstract class _VisitasControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
