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
  if (!Hive.isBoxOpen(Constants.reminderBox)) {
    remindersBox = await Hive.openBox<Reminder>(Constants.reminderBox);
  } else {
    remindersBox = Hive.box<Reminder>(Constants.reminderBox);
  }

  if (!Hive.isBoxOpen(Constants.notificationsBox)) {
    notificationsBox =
        await Hive.openBox<NotificationModel>(Constants.notificationsBox);
  } else {
    notificationsBox = Hive.box<NotificationModel>(Constants.notificationsBox);
  }

  if (!Hive.isBoxOpen(Constants.historyBox)) {
    historyBox = await Hive.openBox<HistoryModel>(Constants.historyBox);
  } else {
    historyBox = Hive.box<HistoryModel>(Constants.historyBox);
  }
}
