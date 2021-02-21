// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'livro_ocorrencia_controller.dart';

final $LivroOcorrenciaController = BindInject(
  (i) => LivroOcorrenciaController(),
  singleton: true,
  lazy: true,
);
// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LivroOcorrenciaController on _LivroOcorrenciaControllerBase, Store {
  final _$valueAtom = Atom(name: '_LivroOcorrenciaControllerBase.value');

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

  final _$_LivroOcorrenciaControllerBaseActionController =
      ActionController(name: '_LivroOcorrenciaControllerBase');

  @override
  void increment() {
    final _$actionInfo = _$_LivroOcorrenciaControllerBaseActionController
        .startAction(name: '_LivroOcorrenciaControllerBase.increment');
    try {
      return super.increment();
    } finally {
      _$_LivroOcorrenciaControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: ${value}
    ''';
  }
}
