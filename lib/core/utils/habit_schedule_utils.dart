import 'package:habitly/core/utils/date_utils.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/entities/habit_frequency.dart';

bool isHabitScheduledOnDate(Habit habit, DateTime date) {
  final startDate = habit.targetDate;
  if (startDate == null) return false;

  final start = AppDateUtils.toDateOnly(startDate);
  final selected = AppDateUtils.toDateOnly(date);

  if (selected.isBefore(start)) return false;

  if (habit.endDate != null) {
    final end = AppDateUtils.toDateOnly(habit.endDate!);
    if (selected.isAfter(end)) return false;
  }

  switch (habit.frequency) {
    case HabitFrequency.hourly:
    case HabitFrequency.daily:
      return true;
    case HabitFrequency.weekly:
      return selected.weekday == start.weekday;
    case HabitFrequency.monthly:
      final daysInMonth = DateTime(selected.year, selected.month + 1, 0).day;
      if (start.day > daysInMonth) {
        return selected.day == daysInMonth;
      }
      return selected.day == start.day;
    case HabitFrequency.customDays:
      final rawInterval = habit.customDays ?? 1;
      final interval = rawInterval < 1 ? 1 : rawInterval;
      final daysDiff = selected.difference(start).inDays;
      return daysDiff % interval == 0;
  }
}
