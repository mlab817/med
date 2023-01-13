import 'package:hive/hive.dart';

part 'history_model.g.dart';

enum MedicineAction { taken, skipped }

extension MedicineActionString on MedicineAction {
  String get string {
    return toString();
  }
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
