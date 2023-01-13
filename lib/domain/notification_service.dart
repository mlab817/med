import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:med/app/constants.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:uuid/uuid.dart';

import '../presentation/resources/strings_manager.dart';

class NotificationService {
  // NotificationService(this._flutterLocalNotificationsPlugin);
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  static const channelId = '123';

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init(callback) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    tz.initializeTimeZones();

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: callback);
  }

  final AndroidNotificationDetails _androidNotificationDetails =
      const AndroidNotificationDetails(
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

  Future<void> showNotifications(
      {String? title, String? body, String? payload}) async {
    await _flutterLocalNotificationsPlugin.show(
      0,
      title ?? "Notification Title",
      body ?? "This is the Notification Body!",
      // RepeatInterval.everyMinute,
      NotificationDetails(android: _androidNotificationDetails),
      // androidAllowWhileIdle: true,
      payload: payload ?? "some payload",
    );
  }

  Future<void> scheduleNotifications(
      {int? id,
      String? title,
      String? body,
      tz.TZDateTime? nextTime,
      String? payload}) async {
    // generate notificationId
    int uuid = (const Uuid()).hashCode;

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id ?? uuid, // set to custom uuid if id is not defined
      title ?? "Time to take your medicine!",
      body ?? "This is the Notification Body!",
      nextTime ?? tz.TZDateTime.now(tz.local).add(const Duration(minutes: 1)),
      NotificationDetails(android: _androidNotificationDetails),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload ?? AppStrings.empty,
    );
  }

  Future<void> cancelNotifications(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
