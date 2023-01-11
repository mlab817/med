import 'package:flutter/material.dart';
import 'package:med/app/di.dart';
import 'package:med/app/init_hive.dart';
import 'package:med/presentation/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initHive();

  await initAppModule();

  runApp(const App());
}
