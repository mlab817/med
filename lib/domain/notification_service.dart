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

    requestPermission();
  }

  Future<void> requestPermission() async {
    var permission = await _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.areNotificationsEnabled() ?? false;

    if (!permission) {
      showNotifications();

      _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()?.requestPermission() ?? Future.value(false);
    }
  }

  final AndroidNotificationDetails _androidNotificationDetails =
  const AndroidNotificationDetails(
    'medicineReminder',
    'medicineChannel',
    channelDescription: 'This is the medicine reminder channel',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
    fullScreenIntent: false,
    sound: RawResourceAndroidNotificationSound('alarm'),
    playSound: true,
    actions: [
      AndroidNotificationAction(
        NotificationActionsId.snooze,
        AppStrings.snooze,
        titleColor: Colors.redAccent,
        showsUserInterface: true,
      ),
      AndroidNotificationAction(
        NotificationActionsId.markAsDone,
        AppStrings.markAsDone,
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

  Future<void> scheduleNotifications({int? id,
    String? title,
    String? body,
    tz.TZDateTime? nextTime,
    String? payload}) async {
    // generate notificationId
    int uuid = (const Uuid()).hashCode;

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id ?? uuid, // set to custom uuid if id is not defined
      title ?? AppStrings.timeToTakeYourMedicine,
      body ?? AppStrings.thisIsTheNotificationBody,
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

  Future<List<PendingNotificationRequest>?>
  getPendingNotificationRequests() async {
    return await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.pendingNotificationRequests();
  }

  Future<void> cancel(int notificationId) async {
    await _flutterLocalNotificationsPlugin.cancel(notificationId);
  }
}
