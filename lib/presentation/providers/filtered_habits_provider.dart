import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/entities/habit_frequency.dart';
import 'package:habitly/presentation/providers/habit_provider.dart';
import 'package:habitly/presentation/providers/selected_date_provider.dart';
import 'package:habitly/presentation/providers/selected_category_provider.dart';

bool _shouldShowOnDate(Habit habit, DateTime selectedDate) {
  final startDate = habit.targetDate;
  if (startDate == null) return false;

  // Normalize to date-only for comparison
  final start = DateTime(startDate.year, startDate.month, startDate.day);
  final selected = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

  // Don't show before start date
  if (selected.isBefore(start)) return false;

  // Don't show after end date
  if (habit.endDate != null) {
    final end = DateTime(habit.endDate!.year, habit.endDate!.month, habit.endDate!.day);
    if (selected.isAfter(end)) return false;
  }

  switch (habit.frequency) {
    case HabitFrequency.hourly:
    case HabitFrequency.daily:
      return true;
    case HabitFrequency.weekly:
      return selected.weekday == start.weekday;
    case HabitFrequency.monthly:
      // Handle shorter months: if start day is 31 and month has 28 days,
      // show on last day of month
      final daysInMonth = DateTime(selected.year, selected.month + 1, 0).day;
      if (start.day > daysInMonth) {
        return selected.day == daysInMonth;
      }
      return selected.day == start.day;
    case HabitFrequency.customDays:
      final interval = habit.customDays ?? 1;
      final daysDiff = selected.difference(start).inDays;
      return daysDiff % interval == 0;
  }
}

/// Filter by date only — used as source data for CategoryFilterBar.
final dateFilteredHabitsProvider = Provider<AsyncValue<List<Habit>>>((ref) {
  final habitAsync = ref.watch(habitProvider);
  final selectedDate = ref.watch(selectedDateProvider);

  return habitAsync.whenData((habits) {
    return habits
        .where((habit) => _shouldShowOnDate(habit, selectedDate))
        .map((habit) => habit.copyWith(
              isCompleted: habit.isCompletedForDate(selectedDate),
            ))
        .toList();
  });
});

/// Filter by date + category — used by home page habit list.
final filteredHabitsProvider = Provider<AsyncValue<List<Habit>>>((ref) {
  final dateFiltered = ref.watch(dateFilteredHabitsProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);

  return dateFiltered.whenData((habits) {
    if (selectedCategory == null) return habits;
    return habits.where((h) => h.category == selectedCategory).toList();
  });
});
