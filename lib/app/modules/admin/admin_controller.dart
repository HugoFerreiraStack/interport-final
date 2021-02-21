import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'admin_controller.g.dart';

@Injectable()
class AdminController = _AdminControllerBase with _$AdminController;

abstract class _AdminControllerBase with Store {
  @observable
  int currentIndex = 0;

  @action
  void upDateCurrentIndex(int index) {
    currentIndex = index;
  }
}
