import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:med/domain/notification_service.dart';

import '../../app/di.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final NotificationService _notificationService =
      instance<NotificationService>();

  // note: await is not added because when await is applied
  // it no longer returns a future
  Future<List<PendingNotificationRequest>?> _getActiveNotifications() async {
    return _notificationService.getPendingNotificationRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextButton(
            onPressed: _clearAllNotifications, child: const Text('Clear All')),
        Expanded(
          child: FutureBuilder<List<PendingNotificationRequest>?>(
            future: _getActiveNotifications(),
            // valueListenable: notificationsBox.listenable(),
            builder: (BuildContext context,
                AsyncSnapshot<List<PendingNotificationRequest>?> snapshot) {
              if (snapshot.data != null) {
                final items = snapshot.data!;

                return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];

                      return Column(
                        children: [
                          Text(item.id.toString()),
                          Text(item.title.toString()),
                          Text(item.body.toString()),
                          Text(item.payload.toString()),
                        ],
                      );
                    });
              }
              return Container();
              // return ListView.builder(
              //   itemCount: box.length,
              //   itemBuilder: (context, index) {
              //     NotificationModel notification = box.getAt(index);
              //
              //     return Column(
              //       children: [
              //         Text(notification.notificationId.toString()),
              //         Text(notification.dateTime),
              //       ],
              //     );
              //   },
              // );
            },
          ),
        ),
      ]),
    ));
  }

  void _clearAllNotifications() async {
    await _notificationService.cancelAllNotifications();
  }
}
