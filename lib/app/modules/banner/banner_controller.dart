import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'banner_controller.g.dart';

@Injectable()
class BannerController = _BannerControllerBase with _$BannerController;

abstract class _BannerControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
