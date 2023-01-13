import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:med/presentation/resources/routes_manager.dart';
import 'package:med/presentation/resources/theme_manager.dart';
import 'package:timezone/timezone.dart' as tz;

import '../domain/notification_service.dart';
import '../presentation/main/main.dart';
import 'constants.dart';
import 'di.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final NotificationService _notificationService =
      instance<NotificationService>();

  final StreamController<String> _streamController = StreamController<String>();

  Future<void> _onDidReceiveBackgroundNotificationResponse(
      NotificationResponse response) async {
    switch (response.actionId) {
      case NotificationActionsId.snooze:
        _handleSnooze(response.payload ?? "");
        break;
      case NotificationActionsId.markAsDone:
        _streamController.add(response.payload ?? "");
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _streamController.add("");
    NotificationService().init(_onDidReceiveBackgroundNotificationResponse);
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(),
      onGenerateRoute: RouteGenerator.getRoute,
      initialRoute: Routes.splashRoute,
      home: StreamBuilder<String>(
          stream: _streamController.stream,
          initialData: "",
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.data != null && snapshot.data?.isNotEmpty == true) {
              final uuid = snapshot.data;
              Future.delayed(Duration.zero, () {
                Navigator.pushNamed(context, Routes.showReminderRoute,
                    arguments: uuid);
              });
            }
            return const MainPage();
          }),
    );
  }

  _handleSnooze(String payload) {
    var nextTime = tz.TZDateTime.now(tz.local).add(const Duration(minutes: 10));
    // retrieve reminder from box
    // create a scheduled notification
    // for 10 mins from now
    _notificationService.scheduleNotifications(
        payload: payload, nextTime: nextTime);
  }
}
