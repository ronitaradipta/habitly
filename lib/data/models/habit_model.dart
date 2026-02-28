import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/entities/habit_frequency.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const _sentinel = Object();

class HabitModel {
  final String id;
  final String name;
  final String iconName;
  final DateTime? targetDate;

  // Reminder fields
  final bool hasReminder;
  final String? reminderTime;

  // Category
  final String? categoryId;

  // Frequency fields
  final String? frequencyName;
  final int? customDays;
  final DateTime? endDate;
  final Map<String, bool> completedDates;

  HabitModel({
    required this.id,
    required this.name,
    required this.iconName,
    this.targetDate,
    this.hasReminder = false,
    this.reminderTime,
    this.categoryId,
    this.frequencyName,
    this.customDays,
    this.endDate,
    this.completedDates = const {},
  });

  Habit toEntity() {
    final frequency = HabitFrequency.fromName(frequencyName);

    return Habit(
      id: id,
      name: name,
      iconName: iconName,
      targetDate: targetDate,
      hasReminder: hasReminder,
      reminderTime: reminderTime,
      categoryId: categoryId,
      frequency: frequency,
      customDays: customDays,
      endDate: endDate,
      completedDates: completedDates,
    );
  }

  factory HabitModel.fromEntity(Habit habit) => HabitModel(
    id: habit.id,
    name: habit.name,
    iconName: habit.iconName,
    targetDate: habit.targetDate,
    hasReminder: habit.hasReminder,
    reminderTime: habit.reminderTime,
    categoryId: habit.categoryId,
    frequencyName: habit.frequency.name,
    customDays: habit.customDays,
    endDate: habit.endDate,
    completedDates: habit.completedDates,
  );

  factory HabitModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    // Parse completedDates from Firestore map
    final rawCompletedDates = data?['completedDates'] as Map<String, dynamic>?;
    final completedDates = rawCompletedDates?.map(
      (key, value) => MapEntry(key, value == true),
    ) ?? {};

    return HabitModel(
      id: snapshot.id,
      name: data?['name'] as String? ?? '',
      iconName: data?['iconName'] as String? ?? 'fitness_center',
      targetDate: (data?['targetDate'] as Timestamp?)?.toDate(),
      hasReminder: data?['hasReminder'] as bool? ?? false,
      reminderTime: data?['reminderTime'] as String?,
      categoryId: data?['categoryId'] as String?,
      frequencyName: data?['frequencyName'] as String?,
      customDays: data?['customDays'] as int?,
      endDate: (data?['endDate'] as Timestamp?)?.toDate(),
      completedDates: completedDates,
    );
  }

  HabitModel copyWith({
    String? id,
    String? name,
    String? iconName,
    Object? targetDate = _sentinel,
    bool? hasReminder,
    Object? reminderTime = _sentinel,
    Object? categoryId = _sentinel,
    Object? frequencyName = _sentinel,
    Object? customDays = _sentinel,
    Object? endDate = _sentinel,
    Map<String, bool>? completedDates,
  }) {
    return HabitModel(
      id: id ?? this.id,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      targetDate: identical(targetDate, _sentinel)
          ? this.targetDate
          : targetDate as DateTime?,
      hasReminder: hasReminder ?? this.hasReminder,
      reminderTime: identical(reminderTime, _sentinel)
          ? this.reminderTime
          : reminderTime as String?,
      categoryId: identical(categoryId, _sentinel)
          ? this.categoryId
          : categoryId as String?,
      frequencyName: identical(frequencyName, _sentinel)
          ? this.frequencyName
          : frequencyName as String?,
      customDays: identical(customDays, _sentinel)
          ? this.customDays
          : customDays as int?,
      endDate: identical(endDate, _sentinel)
          ? this.endDate
          : endDate as DateTime?,
      completedDates: completedDates ?? this.completedDates,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'iconName': iconName,
      'hasReminder': hasReminder,
      'reminderTime': reminderTime,
      'targetDate': targetDate != null ? Timestamp.fromDate(targetDate!) : null,
      'categoryId': categoryId,
      'frequencyName': frequencyName,
      'customDays': customDays,
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'completedDates': completedDates,
    };
  }
}
