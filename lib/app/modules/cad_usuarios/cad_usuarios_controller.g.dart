// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cad_usuarios_controller.dart';

final $CadUsuariosController = BindInject(
  (i) => CadUsuariosController(),
  singleton: true,
  lazy: true,
);

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CadUsuariosController on _CadUsuariosControllerBase, Store {
  final _$valueAtom = Atom(name: '_CadUsuariosControllerBase.value');

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

  final _$_CadUsuariosControllerBaseActionController =
      ActionController(name: '_CadUsuariosControllerBase');

  @override
  void increment() {
    final _$actionInfo = _$_CadUsuariosControllerBaseActionController
        .startAction(name: '_CadUsuariosControllerBase.increment');
    try {
      return super.increment();
    } finally {
      _$_CadUsuariosControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: ${value}
    ''';
  }
}
