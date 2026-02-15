import 'package:habitly/domain/entities/habit.dart';

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

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'iconCodePoint': iconCodePoint,
    'isCompleted': isCompleted,
    'completionTime': completionTime,
    'reminderPeriodName': reminderPeriodName,
    'targetDate': targetDate?.toIso8601String(),
  };

  factory HabitModel.fromJson(Map<String, dynamic> json) => HabitModel(
    id: json['id'] as String,
    name: json['name'] as String,
    iconCodePoint: json['iconCodePoint'] as int? ?? 0xe8d8,
    isCompleted: json['isCompleted'] as bool? ?? false,
    completionTime: json['completionTime'] as String?,
    reminderPeriodName: json['reminderPeriodName'] as String?,
    targetDate: json['targetDate'] != null
        ? DateTime.parse(json['targetDate'] as String)
        : null,
  );
}
