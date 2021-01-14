import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'politicas_da_empresa_controller.g.dart';

@Injectable()
class PoliticasDaEmpresaController = _PoliticasDaEmpresaControllerBase
    with _$PoliticasDaEmpresaController;

abstract class _PoliticasDaEmpresaControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
