import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:med/app/app.dart';
import 'package:med/app/di.dart';
import 'package:med/app/init_hive.dart';

import 'domain/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initHive();

  await initAppModule();

  // await initNotificationsModule();

  await NotificationService().init();

  // headlessTask allows background task to run even when
  // app is terminated
  BackgroundFetch.registerHeadlessTask(backgroundFetchTask);

  runApp(const App());
}
