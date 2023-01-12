import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:med/app/constants.dart';
import 'package:med/app/init_hive.dart';
import 'package:med/data/models/reminder_model.dart';
import 'package:timezone/timezone.dart';
import 'package:uuid/uuid.dart';

import '../app/di.dart';
import '../data/models/history_model.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  NotificationService(this._flutterLocalNotificationsPlugin);

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    _initialized = true;

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'medicineReminder',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      fullScreenIntent: true,
      sound: RawResourceAndroidNotificationSound('mix'),
      playSound: true,
      actions: [
        AndroidNotificationAction(
          NotificationActionsId.snooze,
          "Snooze",
          titleColor: Colors.redAccent,
          showsUserInterface: true,
        ),
        AndroidNotificationAction(
          NotificationActionsId.markAsDone,
          "Mark as Done",
          titleColor: Colors.lightGreen,
          showsUserInterface: true,
        ),
      ],
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    var initializationSettings =
        const InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
      final Reminder reminder = remindersBox.get(response.payload!);

      switch (response.actionId) {
        case NotificationActionsId.snooze:
          // handle snooze by scheduling a new notification
          var location = getLocation(TzLocation.asiaManila);

          var nextTime = TZDateTime.from(
              DateTime.now().add(const Duration(minutes: 10)), location);

          _flutterLocalNotificationsPlugin.zonedSchedule(
            (const Uuid()).hashCode,
            'Time for your medicine!',
            'Take ${reminder.name} now',
            nextTime,
            notificationDetails,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            androidAllowWhileIdle: true,
            payload: response.payload!,
            // uuid of reminder so it can be retrieved
            matchDateTimeComponents: DateTimeComponents.dateAndTime,
          );
          break;
        case NotificationActionsId.markAsDone:
          // create a record in history
          HistoryModel history = HistoryModel(
            reminder.name,
            DateTime.now().toString(),
          );

          historyBox.add(history);

          break;
        default:
          return;
      }
    });
  }
}

Future<void> initNotificationsModule() async {
  NotificationService notificationService = instance<NotificationService>();

  return await notificationService.initialize();
}
