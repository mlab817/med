import 'package:hive/hive.dart';

part 'history_model.g.dart';

class MedicineAction {
  static const String taken = "taken";
  static const String skipped = "skipped";
  static const String noAction = "no action";
}

@HiveType(typeId: 2)
class HistoryModel extends HiveObject {
  @HiveField(0)
  String medicineName;

  @HiveField(1)
  String takenAt;

  @HiveField(2)
  String medicineAction;

  HistoryModel(
    this.medicineName,
    this.takenAt,
    this.medicineAction,
  );
}
