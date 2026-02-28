import 'package:habitly/domain/entities/category.dart' show HabitCategory;
import 'package:habitly/domain/entities/habit_frequency.dart';

const _sentinel = Object();

class Habit {
  final String id;
  final String name;
  final String iconName;
  final bool isCompleted;
  final DateTime? targetDate;

  // Reminder fields
  final bool hasReminder;
  final String? reminderTime; // Format: "HH:mm" (e.g., "07:00", "13:30")

  // Category
  final String? categoryId;

  // Frequency fields
  final HabitFrequency frequency;
  final int? customDays; // Only meaningful when frequency == customDays
  final DateTime? endDate; // null = habit runs forever

  // Per-date completion tracking (key format: "yyyy-MM-dd")
  final Map<String, bool> completedDates;

  Habit({
    required this.id,
    required this.name,
    required this.iconName,
    this.isCompleted = false,
    this.targetDate,
    this.hasReminder = false,
    this.reminderTime,
    this.categoryId,
    this.frequency = HabitFrequency.daily,
    this.customDays,
    this.endDate,
    this.completedDates = const {},
  });

  // Date key helper
  static String dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  // Per-date completion check
  bool isCompletedForDate(DateTime date) =>
      completedDates[dateKey(date)] == true;

  // Reminder helpers
  String get formattedReminderTime {
    if (!hasReminder || reminderTime == null) return 'No reminder';
    final parts = reminderTime!.split(':');
    final hour = int.parse(parts[0]);
    final minute = parts[1];
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$displayHour:$minute $period';
  }

  // Category helper
  HabitCategory? get category => HabitCategory.fromId(categoryId);

  Habit copyWith({
    String? id,
    String? name,
    String? iconName,
    bool? isCompleted,
    Object? targetDate = _sentinel,
    bool? hasReminder,
    Object? reminderTime = _sentinel,
    Object? categoryId = _sentinel,
    HabitFrequency? frequency,
    Object? customDays = _sentinel,
    Object? endDate = _sentinel,
    Map<String, bool>? completedDates,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      isCompleted: isCompleted ?? this.isCompleted,
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
      frequency: frequency ?? this.frequency,
      customDays: identical(customDays, _sentinel)
          ? this.customDays
          : customDays as int?,
      endDate: identical(endDate, _sentinel)
          ? this.endDate
          : endDate as DateTime?,
      completedDates: completedDates ?? this.completedDates,
    );
  }
}
