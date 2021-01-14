import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'cameras_controller.g.dart';

@Injectable()
class CamerasController = _CamerasControllerBase with _$CamerasController;

abstract class _CamerasControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
