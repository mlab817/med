import 'package:hive/hive.dart';

part 'history_model.g.dart';

@HiveType(typeId: 2)
class HistoryModel extends HiveObject {
  @HiveField(0)
  String medicineName;

  @HiveField(1)
  String takenAt;

  HistoryModel(
    this.medicineName,
    this.takenAt,
  );
}
