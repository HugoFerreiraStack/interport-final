// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visitas_controller.dart';

final $VisitasController = BindInject(
  (i) => VisitasController(),
  singleton: true,
  lazy: true,
);

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$VisitasController on _VisitasControllerBase, Store {
  final _$valueAtom = Atom(name: '_VisitasControllerBase.value');

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

  final _$_VisitasControllerBaseActionController =
      ActionController(name: '_VisitasControllerBase');

  @override
  void increment() {
    final _$actionInfo = _$_VisitasControllerBaseActionController.startAction(
        name: '_VisitasControllerBase.increment');
    try {
      return super.increment();
    } finally {
      _$_VisitasControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: ${value}
    ''';
  }
}
