import 'package:habitly/domain/entities/habit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HabitModel {
  final String id;
  final String name;
  final int iconCodePoint;
  final bool isCompleted;
  final String? completionTime;
  final String? reminderPeriodName;
  final DateTime? targetDate;

  HabitModel({
    required this.id,
    required this.name,
    required this.iconCodePoint,
    this.isCompleted = false,
    this.completionTime,
    this.reminderPeriodName,
    this.targetDate,
  });

  Habit toEntity() => Habit(
    id: id,
    name: name,
    iconCodePoint: iconCodePoint,
    isCompleted: isCompleted,
    completionTime: completionTime,
    reminderPeriod: ReminderPeriodExtension.fromId(reminderPeriodName),
    targetDate: targetDate,
  );

  factory HabitModel.fromEntity(Habit habit) => HabitModel(
    id: habit.id,
    name: habit.name,
    iconCodePoint: habit.iconCodePoint,
    isCompleted: habit.isCompleted,
    completionTime: habit.completionTime,
    reminderPeriodName: habit.reminderPeriod?.name,
    targetDate: habit.targetDate,
  );

  factory HabitModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return HabitModel(
      id: snapshot.id,
      name: data?['name'] as String? ?? '',
      iconCodePoint: data?['iconCodePoint'] as int? ?? 0xe8d8,
      isCompleted: data?['isCompleted'] as bool? ?? false,
      completionTime: data?['completionTime'] as String?,
      reminderPeriodName: data?['reminderPeriodName'] as String?,
      targetDate: (data?['targetDate'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'iconCodePoint': iconCodePoint,
      'isCompleted': isCompleted,
      'completionTime': completionTime,
      'reminderPeriodName': reminderPeriodName,
      'targetDate': targetDate != null ? Timestamp.fromDate(targetDate!) : null,
    };
  }
}
