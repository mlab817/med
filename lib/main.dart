import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:med/app/di.dart';
import 'package:med/app/init_hive.dart';
import 'package:med/presentation/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initHive();

  await initAppModule();

// initialize alarm manager
  await AndroidAlarmManager.initialize();

  runApp(const App());
}
