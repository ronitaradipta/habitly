import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/presentation/providers/filtered_habits_provider.dart';
import 'package:habitly/presentation/providers/habit_sort_provider.dart';

final sortedHabitsProvider = Provider<AsyncValue<List<Habit>>>((ref) {
  final filtered = ref.watch(filteredHabitsProvider);
  final sortOption = ref.watch(habitSortProvider);

  if (sortOption == HabitSortOption.defaultOrder) return filtered;

  return filtered.whenData((habits) {
    final sorted = List<Habit>.from(habits);
    sorted.sort((a, b) {
      final primary = switch (sortOption) {
        HabitSortOption.alphabeticalAsc =>
          a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        HabitSortOption.alphabeticalDesc =>
          b.name.toLowerCase().compareTo(a.name.toLowerCase()),
        HabitSortOption.completedLast =>
          (a.isCompleted ? 1 : 0).compareTo(b.isCompleted ? 1 : 0),
        HabitSortOption.completedFirst =>
          (b.isCompleted ? 1 : 0).compareTo(a.isCompleted ? 1 : 0),
        HabitSortOption.category => _compareCategory(a, b),
        HabitSortOption.defaultOrder => 0,
      };
      if (primary != 0) return primary;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    return sorted;
  });
});

int _compareCategory(Habit a, Habit b) {
  final aCat = a.categoryId ?? '';
  final bCat = b.categoryId ?? '';
  if (aCat.isEmpty && bCat.isEmpty) return 0;
  if (aCat.isEmpty) return 1;
  if (bCat.isEmpty) return -1;
  return aCat.compareTo(bCat);
}
