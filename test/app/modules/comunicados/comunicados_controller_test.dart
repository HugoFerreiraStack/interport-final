import 'package:flutter_modular/flutter_modular_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:interport_app/app/modules/comunicados/comunicados_controller.dart';
import 'package:interport_app/app/modules/comunicados/comunicados_module.dart';

void main() {
  initModule(ComunicadosModule());
  // ComunicadosController comunicados;
  //
  setUp(() {
    //     comunicados = ComunicadosModule.to.get<ComunicadosController>();
  });

  group('ComunicadosController Test', () {
    //   test("First Test", () {
    //     expect(comunicados, isInstanceOf<ComunicadosController>());
    //   });

    //   test("Set Value", () {
    //     expect(comunicados.value, equals(0));
    //     comunicados.increment();
    //     expect(comunicados.value, equals(1));
    //   });
  });
}
