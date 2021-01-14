import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'eventos_controller.g.dart';

@Injectable()
class EventosController = _EventosControllerBase with _$EventosController;

abstract class _EventosControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
