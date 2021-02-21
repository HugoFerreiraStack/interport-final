import 'package:flutter/material.dart';
import 'package:interport_app/app/app_module.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter_modular/flutter_modular.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ModularApp(module: AppModule()));
}
