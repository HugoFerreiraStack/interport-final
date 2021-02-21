// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cad_condominios_controller.dart';

final $CadCondominiosController = BindInject(
  (i) => CadCondominiosController(),
  singleton: true,
  lazy: true,
);
// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CadCondominiosController on _CadCondominiosControllerBase, Store {
  final _$valueAtom = Atom(name: '_CadCondominiosControllerBase.value');

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

  final _$_CadCondominiosControllerBaseActionController =
      ActionController(name: '_CadCondominiosControllerBase');

  @override
  void increment() {
    final _$actionInfo = _$_CadCondominiosControllerBaseActionController
        .startAction(name: '_CadCondominiosControllerBase.increment');
    try {
      return super.increment();
    } finally {
      _$_CadCondominiosControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: ${value}
    ''';
  }
}
