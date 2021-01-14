// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'panico_controller.dart';

final $PanicoController = BindInject(
  (i) => PanicoController(),
  singleton: true,
  lazy: true,
);

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PanicoController on _PanicoControllerBase, Store {
  final _$valueAtom = Atom(name: '_PanicoControllerBase.value');

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

  final _$_PanicoControllerBaseActionController =
      ActionController(name: '_PanicoControllerBase');

  @override
  void increment() {
    final _$actionInfo = _$_PanicoControllerBaseActionController.startAction(
        name: '_PanicoControllerBase.increment');
    try {
      return super.increment();
    } finally {
      _$_PanicoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: ${value}
    ''';
  }
}
