// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'politicas_da_empresa_controller.dart';

final $PoliticasDaEmpresaController = BindInject(
  (i) => PoliticasDaEmpresaController(),
  singleton: true,
  lazy: true,
);

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PoliticasDaEmpresaController
    on _PoliticasDaEmpresaControllerBase, Store {
  final _$valueAtom = Atom(name: '_PoliticasDaEmpresaControllerBase.value');

  @override
  int get value {
    _$valueAtom.reportRead();
    return super.value;
  }

  @override
  set value(int value) {
    _$valueAtom.reportWrite(value, super.value, () {
      super.value = value;
    });
  }

  final _$_PoliticasDaEmpresaControllerBaseActionController =
      ActionController(name: '_PoliticasDaEmpresaControllerBase');

  @override
  void increment() {
    final _$actionInfo = _$_PoliticasDaEmpresaControllerBaseActionController
        .startAction(name: '_PoliticasDaEmpresaControllerBase.increment');
    try {
      return super.increment();
    } finally {
      _$_PoliticasDaEmpresaControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: ${value}
    ''';
  }
}
