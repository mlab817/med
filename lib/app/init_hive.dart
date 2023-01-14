import 'package:hive_flutter/hive_flutter.dart';
import 'package:med/app/constants.dart';
import 'package:med/data/models/history_model.dart';
import 'package:med/data/models/notification_model.dart';
import 'package:med/data/models/reminder_model.dart';

late Box remindersBox;
late Box notificationsBox;
late Box historyBox;

Future<void> initHive() async {
  await Hive.initFlutter();

  // register the adapter for reminders
  Hive.registerAdapter(ReminderAdapter());
  Hive.registerAdapter(NotificationModelAdapter());
  Hive.registerAdapter(HistoryModelAdapter());

  // open box named reminders if not open
  if (!Hive.isBoxOpen(HiveBoxes.reminderBox)) {
    remindersBox = await Hive.openBox<Reminder>(HiveBoxes.reminderBox);
  } else {
    remindersBox = Hive.box<Reminder>(HiveBoxes.reminderBox);
  }

  if (!Hive.isBoxOpen(HiveBoxes.notificationsBox)) {
    notificationsBox =
        await Hive.openBox<NotificationModel>(HiveBoxes.notificationsBox);
  } else {
    notificationsBox = Hive.box<NotificationModel>(HiveBoxes.notificationsBox);
  }

  if (!Hive.isBoxOpen(HiveBoxes.historyBox)) {
    historyBox = await Hive.openBox<HistoryModel>(HiveBoxes.historyBox);
  } else {
    historyBox = Hive.box<HistoryModel>(HiveBoxes.historyBox);
  }
}
