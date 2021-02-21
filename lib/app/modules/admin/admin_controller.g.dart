// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_controller.dart';

final $AdminController = BindInject(
  (i) => AdminController(),
  singleton: true,
  lazy: true,
);
// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AdminController on _AdminControllerBase, Store {
  final _$currentIndexAtom = Atom(name: '_AdminControllerBase.currentIndex');

  @override
  int get currentIndex {
    _$currentIndexAtom.reportRead();
    return super.currentIndex;
  }

  @override
  set currentIndex(int value) {
    _$currentIndexAtom.reportWrite(value, super.currentIndex, () {
      super.currentIndex = value;
    });
  }

  final _$_AdminControllerBaseActionController =
      ActionController(name: '_AdminControllerBase');

  @override
  void upDateCurrentIndex(int index) {
    final _$actionInfo = _$_AdminControllerBaseActionController.startAction(
        name: '_AdminControllerBase.upDateCurrentIndex');
    try {
      return super.upDateCurrentIndex(index);
    } finally {
      _$_AdminControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentIndex: ${currentIndex}
    ''';
  }
}
