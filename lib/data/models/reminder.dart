import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'reminder.g.dart';

@HiveType(typeId: 0)
class Reminder extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String form;

  @HiveField(2)
  int amount;

  @HiveField(3)
  String illness;

  @HiveField(4)
  bool takeEveryday;

  @HiveField(5)
  String takeTime;

  Reminder(
    this.name,
    this.form,
    this.amount,
    this.illness,
    this.takeEveryday,
    this.takeTime,
  );
}
