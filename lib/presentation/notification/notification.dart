/**
 * see https://blog.codemagic.io/flutter-local-notifications/ for more
 * information on setting up flutter_local_notifications
 */
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  @override
  void initState() {
    super.initState();

    _initializeNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: _showNotif,
          child: const Text('Show notification'),
        ),
      ),
    );
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    //
    final String? payload = notificationResponse.payload;

    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }

    // do something
  }


  Future<void> _showNotif() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        fullScreenIntent: true,
        sound: RawResourceAndroidNotificationSound('mix'),
        playSound: true,
        actions: [
          AndroidNotificationAction(
            "snooze",
            "Snooze",
            titleColor: Colors.redAccent,
          ),
          AndroidNotificationAction(
            "done",
            "Mark as Done",
            titleColor: Colors.lightGreen,
          ),
        ]);

    // more types of notifications can be added here like for ios
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    // generate a unique id using the current timestamp
    int notificationId = DateTime
        .now()
        .millisecondsSinceEpoch
        .toInt();

    await _flutterLocalNotificationsPlugin.show(
      notificationId,
      'Take your medicine!',
      'Take paracetamol 500mg tablet now', // replace with actual medicine
      notificationDetails,
      payload: 'item x', // can add details here

    );
  }
}
