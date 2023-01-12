import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:med/presentation/resources/color_manager.dart';
import 'package:med/presentation/resources/routes_manager.dart';
import 'package:med/presentation/resources/size_manager.dart';

import '../../app/constants.dart';
import 'history/history.dart';
import 'home/home.dart';
import 'hotlines/hotlines.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  int _currentIndex = 0;

  final List<Widget> _children = [
    const HomePage(),
    const HistoryPage(),
    const HotlinesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    String formattedDate = DateFormat("MMM dd, yyyy").format(now);

    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: _getAppBar(formattedDate),
      body: _children[_currentIndex],
      bottomSheet: _getBottomSheet(),
      bottomNavigationBar: _getBottomNavigator(),
    );
  }

  PreferredSizeWidget _getAppBar(String formattedDate) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: false,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Hello there!', style: Theme.of(context).textTheme.subtitle2),
          Text(
            "Today is $formattedDate",
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      ),
      automaticallyImplyLeading: false,
      elevation: AppSize.s0,
      actions: [
        if (kDebugMode)
          IconButton(
            onPressed: _testNotifications,
            icon: Icon(
              Icons.notifications,
              color: ColorManager.darkgray,
            ),
          ),
      ],
    );
  }

  Widget _getBottomSheet() {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            height: AppSize.s50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.medicineRoute);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.lightred,
              ),
              child: const Text('Add Medicine'),
            ),
          ),
          SizedBox(
            height: AppSize.s50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.tipRoute);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.white,
              ),
              child: Text(
                'Tips for today',
                style: TextStyle(
                  color: ColorManager.blue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getBottomNavigator() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      backgroundColor: ColorManager.blue,
      unselectedItemColor: ColorManager.darkgray,
      selectedItemColor: ColorManager.white,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_view_month),
          label: "Schedule",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: "History",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.call),
          label: "Hotlines",
        ),
      ],
      onTap: (int index) {
        // if currentIndex is just the same, do not do anything
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }

  Future<void> _testNotifications() async {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Test notification sent.')));

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

    // more types of notifications can be added here like for ios
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    // test notification
    await _flutterLocalNotificationsPlugin.show(
      0,
      'test',
      'body',
      notificationDetails,
      payload: 'test stuff',
    );
  }
}
