import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'livro_ocorrencia_controller.g.dart';

@Injectable()
class LivroOcorrenciaController = _LivroOcorrenciaControllerBase
    with _$LivroOcorrenciaController;

abstract class _LivroOcorrenciaControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
