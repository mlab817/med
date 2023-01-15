import 'package:flutter/cupertino.dart';
import 'package:med/domain/notification_service.dart';
import 'package:med/presentation/medicine/medicine.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:uuid/uuid.dart';

import '../data/models/notification_model.dart';
import '../data/models/reminder_model.dart';
import '../presentation/resources/strings_manager.dart';
import 'di.dart';
import 'init_hive.dart';

void addReminder(ReminderInput input) {
  final reminderUuid = _generateNotificationId();

  // get the first startTime
  final startTime = input.startTimes[0];

  // add the reminder to the hive database
  Reminder newReminder = Reminder(
    reminderUuid,
    input.name,
    input.frequency,
    startTime?.toIso8601String() ?? "",
    // first start time, this can introduce a bug if the dose has already passed for the day
    input.illness,
    input.duration,
    input.stock, // remaining stock
  );
  remindersBox.add(newReminder);

  // save the notification first
  // then schedule them one by one
  for (DateTime? dt in input.startTimes) {
    if (dt != null) {
      // create a notification id by applying hashCode to generateNotificationId result
      var finalDt = dt;

      // if the dt is past, add 1 day
      if (DateTime.now().isAfter(dt)) {
        finalDt = dt.add(const Duration(days: 1));
      }

      // newReminder.notifications?.add(newNotif);
      newReminder.schedules.add(finalDt.toIso8601String());

      createNotifications(reminderUuid, finalDt, input.duration, input.name);
    }
  }
  newReminder.save();
}

void createNotifications(String reminderUuid, DateTime startAt, int duration,
    String medicineName) async {
  final NotificationService notificationService =
      instance<NotificationService>();

  // generate startNotifId
  int notifId = _generateNotificationId().hashCode;

  // iterate and add 1 day
  for (int i = 0; i < duration; i++) {
    // just add i to make sure notifs are unique
    // need to store this to db
    final nextDateTime = tz.TZDateTime.from(
        startAt.add(
          Duration(days: i),
        ),
        tz.local);

    // if the incoming date is done, skip it
    if (nextDateTime.isBefore(tz.TZDateTime.now(tz.local))) {
      continue;
    }

    int finalNotifId = notifId + i;

    // create the notification
    await notificationService.scheduleNotifications(
      id: finalNotifId,
      title: AppStrings.timeForYourMedicine,
      body: 'Take $medicineName now.',
      nextTime: nextDateTime,
      payload: reminderUuid,
    );

    saveNotificationToHive(finalNotifId, nextDateTime, reminderUuid);
  }
}

void saveNotificationToHive(int notifId, DateTime dt, String reminderUuid) {
  NotificationModel newNotif =
      NotificationModel(notifId, dt.toIso8601String(), reminderUuid);

  notificationsBox.add(newNotif);
}

// get the notifications with a particular reminder uuid and the deleted datetime
void removeNotifications(String reminderUuid, DateTime dateTime) {
  final NotificationService notificationService =
      instance<NotificationService>();

  //
  final notificationsToDelete = notificationsBox.values
      .where((element) => compareElements(element, reminderUuid, dateTime));

  debugPrint("notificationsToDelete ${notificationsToDelete.length}");

  for (var notification in notificationsToDelete) {
    notificationsBox.delete(notification.key);

    // delete also actual notification
    notificationService.cancel(notification.notificationId);
  }
}

bool compareElements(
    NotificationModel element, String reminderUuid, DateTime dateTime) {
  return element.reminderUuid == reminderUuid &&
      tz.TZDateTime.parse(tz.local, element.dateTime).millisecondsSinceEpoch ==
          dateTime.millisecondsSinceEpoch;
}

String _generateNotificationId() {
  return const Uuid().v4();
}
