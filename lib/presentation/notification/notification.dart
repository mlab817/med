/// see https://blog.codemagic.io/flutter-local-notifications/ for more
/// information on setting up flutter_local_notifications
import 'dart:isolate';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:med/app/preferences.dart';
import 'package:med/presentation/resources/routes_manager.dart';
import 'package:med/presentation/resources/size_manager.dart';
import 'package:uuid/uuid.dart';

import '../../app/di.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AppPreferences _appPreferences = instance<AppPreferences>();

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

    _appPreferences
        .getNotificationRequestPermissionGranted()
        .then((notificationRequestPermissionGranted) {
      debugPrint(notificationRequestPermissionGranted.toString());
      if (notificationRequestPermissionGranted) {
        // do not do anything
        debugPrint("permission already granted");
      } else {
        _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestPermission();
        _appPreferences.setNotificationRequestPermissionGranted();
      }
    });
  }

  void _playAlarm() async {
    var time = DateTime.now().add(const Duration(seconds: 5));

    await AndroidAlarmManager.periodic(
      const Duration(seconds: 60),
      0,
      _callback,
      wakeup: true,
      startAt: time,
    );
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _playAlarm,
              child: const Text(
                'Play alarm!',
              ),
            ),
            const SizedBox(
              height: AppSize.s100,
            ),
            ElevatedButton(
              onPressed: _showNotif,
              child: const Text('Show notification!'),
            ),
            const SizedBox(
              height: AppSize.s100,
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.homeRoute);
              },
              child: const Text('Proceed to Home'),
            )
          ],
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
            // sound: RawResourceAndroidNotificationSound('mix'),
            playSound: true,
            // audioAttributesUsage: AudioAttributesUsage.alarm,
            actions: [
          AndroidNotificationAction(
            "snooze",
            "Snooze",
            titleColor: Colors.redAccent,
            showsUserInterface: true,
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

    await _flutterLocalNotificationsPlugin.show(
      _generateNotificationId(),
      'Take your medicine!',
      'Take paracetamol 500mg tablet now', // replace with actual medicine
      notificationDetails,
      payload: 'item x', // can add details here
    );
  }

  // generate an int id using uuid
  int _generateNotificationId() {
    var uuid = const Uuid();
    return uuid.hashCode;
  }

  static void _callback() {
    final DateTime now = DateTime.now();
    final int isolateId = Isolate.current.hashCode;
    debugPrint("[$now] Hello, world! isolate=$isolateId function='$_callback'");
  }
}

// @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorManager.white,
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(AppPadding.p12),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const SizedBox(
//                 height: AppSize.s50,
//               ),
//               Expanded(
//                 child: Lottie.asset(JsonAssets.alarmClockJson),
//               ),
//               Text(
//                 'Some information regarding the medicine!',
//                 style: getBoldStyle(
//                   color: ColorManager.primary,
//                   fontSize: FontSize.s24,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(
//                 height: AppSize.s100,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: <Widget>[
//                   Column(
//                     children: [
//                       InkWell(
//                         child: Container(
//                           width: AppSize.s60,
//                           height: AppSize.s60,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: ColorManager.red,
//                           ),
//                           child: const Icon(
//                             Icons.snooze,
//                             color: Colors.white,
//                           ),
//                         ),
//                         onTap: () {
//                           // Do something when the button is tapped
//                         },
//                       ),
//                       const SizedBox(
//                         height: AppSize.s10,
//                       ),
//                       const Text('Snooze'),
//                     ],
//                   ),
//                   Column(
//                     children: [
//                       InkWell(
//                         onTap: _showNotif,
//                         child: Container(
//                           width: AppSize.s60,
//                           height: AppSize.s60,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: ColorManager.green,
//                           ),
//                           child: const Icon(
//                             Icons.done,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: AppSize.s10,
//                       ),
//                       const Text('Mark as done'),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: AppSize.s60,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
