import 'package:hive_flutter/hive_flutter.dart';
import 'package:med/app/constants.dart';
import 'package:med/data/models/reminder.dart';

late Box remindersBox;

Future<void> initHive() async {
  await Hive.initFlutter();

  // register the adapter for reminders
  Hive.registerAdapter(ReminderAdapter());

  // open box named reminders if not open
  if (!Hive.isBoxOpen(Constants.reminderBox)) {
    remindersBox = await Hive.openBox(Constants.reminderBox);
  } else {
    remindersBox = Hive.box(Constants.reminderBox);
  }
}
