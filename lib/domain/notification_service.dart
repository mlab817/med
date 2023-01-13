import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:med/app/constants.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../app/init_hive.dart';
import '../data/models/history_model.dart';

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

  Future<void> init() async {
    debugPrint("initialized notificationService");

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid, iOS: null, macOS: null);

    tz.initializeTimeZones();

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            onDidReceiveBackgroundNotificationResponse,
        onDidReceiveBackgroundNotificationResponse:
            onDidReceiveBackgroundNotificationResponse);
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
      AndroidNotificationAction('cancel', 'Cancel Notifications'),
    ],
  );

  Future<void> showNotifications({String? title, String? body}) async {
    await _flutterLocalNotificationsPlugin.periodicallyShow(
      0,
      title ?? "Notification Title",
      body ?? "This is the Notification Body!",
      RepeatInterval.everyMinute,
      NotificationDetails(android: _androidNotificationDetails),
      androidAllowWhileIdle: true,
    );
  }

  Future<void> scheduleNotifications({tz.TZDateTime? nextTime}) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        "Notification Title",
        "This is the Notification Body!",
        nextTime ?? tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        NotificationDetails(android: _androidNotificationDetails),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> cancelNotifications(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}

Future<void> onDidReceiveNotificationResponse(
    NotificationResponse response) async {
  debugPrint("reminder ${response.actionId.toString()}");

  switch (response.actionId) {
    case NotificationActionsId.snooze:
      NotificationService()
          .showNotifications(title: 'Snoozed title', body: 'Snoozed body');
      break;
    case NotificationActionsId.markAsDone:
      // create a record in history
      HistoryModel history = HistoryModel(
        'Paracetamol',
        DateTime.now().toString(),
      );
      //
      historyBox.add(history);
      //
      break;
    default:
      return;
  }
}

Future<void> onDidReceiveBackgroundNotificationResponse(
    NotificationResponse response) async {
  switch (response.actionId) {
    case NotificationActionsId.snooze:
      // handle background task
      BackgroundFetch.scheduleTask(TaskConfig(
        taskId: NotificationActionsId.snooze,
        delay: 5000,
        periodic: false,
        forceAlarmManager: false,
        stopOnTerminate: false,
        startOnBoot: true,
        enableHeadless: true,
        requiredNetworkType: NetworkType.NONE,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
      ));
      break;
    case NotificationActionsId.markAsDone:
      BackgroundFetch.scheduleTask(TaskConfig(
        taskId: NotificationActionsId.markAsDone,
        delay: 5000,
        periodic: false,
        forceAlarmManager: false,
        stopOnTerminate: false,
        startOnBoot: true,
        enableHeadless: true,
        requiredNetworkType: NetworkType.NONE,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
      ));
      break;
    case 'cancel':
      NotificationService().cancelAllNotifications();
      break;
    default:
      return;
  }
}

@pragma('vm:entry-point')
void backgroundFetchTask(String taskId) async {
  switch (taskId) {
    case NotificationActionsId.snooze:
      await NotificationService().scheduleNotifications(
        nextTime: tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      );
      debugPrint("snoozed for 10 mins");
      break;
    case NotificationActionsId.markAsDone:
      HistoryModel history = HistoryModel(
        'Paracetamol',
        DateTime.now().toString(),
      );
      //
      historyBox.add(history);
      debugPrint("added history");
      break;
    default:
      debugPrint("no task detected");
      break;
  }
  BackgroundFetch.finish(taskId);
}
