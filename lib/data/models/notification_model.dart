import 'package:hive/hive.dart';

part 'notification_model.g.dart';

@HiveType(typeId: 1)
class NotificationModel extends HiveObject {
  @HiveField(0)
  int notificationId; // note that notification can only be assigned int

  @HiveField(1)
  String dateTime;

  NotificationModel(
    this.notificationId,
    this.dateTime,
  );
}
