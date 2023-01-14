import 'package:hive/hive.dart';

part 'reminder_model.g.dart';

@HiveType(typeId: 0)
class Reminder extends HiveObject {
  @HiveField(0)
  String uuid;

  @HiveField(1)
  String name; // name of medicine

  @HiveField(2)
  int frequency; // how many times per day user need to take medicine

  @HiveField(3)
  String startAt; // earliest start time

  @HiveField(4)
  String ailmentName; // what ailment the user is taking the medicine for

  @HiveField(5)
  int numberOfDays;

  @HiveField(6)
  int remainingStock;

  @HiveField(7)
  // HiveList<NotificationModel>? notifications;
  List<String> schedules = [];

  Reminder(this.uuid, this.name, this.frequency, this.startAt, this.ailmentName,
      this.numberOfDays, this.remainingStock);
}
