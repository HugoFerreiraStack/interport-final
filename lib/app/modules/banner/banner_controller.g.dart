// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_controller.dart';

final $BannerController = BindInject(
  (i) => BannerController(),
  singleton: true,
  lazy: true,
);

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$BannerController on _BannerControllerBase, Store {
  final _$valueAtom = Atom(name: '_BannerControllerBase.value');

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

  final _$_BannerControllerBaseActionController =
      ActionController(name: '_BannerControllerBase');

  @override
  void increment() {
    final _$actionInfo = _$_BannerControllerBaseActionController.startAction(
        name: '_BannerControllerBase.increment');
    try {
      return super.increment();
    } finally {
      _$_BannerControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: ${value}
    ''';
  }
}
