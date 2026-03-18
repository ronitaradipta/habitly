import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/presentation/providers/habit_provider.dart';
import 'package:habitly/presentation/providers/selected_date_provider.dart';
import 'package:habitly/presentation/providers/selected_category_provider.dart';
import 'package:habitly/core/utils/habit_schedule_utils.dart';

/// Filter by date only — used as source data for CategoryFilterBar.
final dateFilteredHabitsProvider = Provider<AsyncValue<List<Habit>>>((ref) {
  final habitAsync = ref.watch(habitProvider);
  final selectedDate = ref.watch(selectedDateProvider);

  return habitAsync.whenData((habits) {
    return habits
        .where((habit) => isHabitScheduledOnDate(habit, selectedDate))
        .map(
          (habit) => habit.copyWith(
            isCompleted: habit.isCompletedForDate(selectedDate),
          ),
        )
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
