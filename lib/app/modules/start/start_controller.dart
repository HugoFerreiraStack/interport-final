import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'start_controller.g.dart';

@Injectable()
class StartController = _StartControllerBase with _$StartController;

abstract class _StartControllerBase with Store {
  @observable
  int currentIndex = 0;

  @action
  void upDateCurrentIndex(int index) {
    currentIndex = index;
  }
}
