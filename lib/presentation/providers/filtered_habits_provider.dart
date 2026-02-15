import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/utils/date_utils.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/presentation/providers/auth_provider.dart';
import 'package:habitly/presentation/providers/habit_provider.dart';
import 'package:habitly/presentation/providers/selected_date_provider.dart';

final filteredHabitsProvider = Provider<AsyncValue<List<Habit>>>((ref) {
  final email = ref.watch(currentUserEmailProvider);
  if (email == null) return const AsyncValue.data([]);

  final habitAsync = ref.watch(habitProvider(email));
  final selectedDate = ref.watch(selectedDateProvider);

  return habitAsync.whenData((habits) {
    return habits.where((habit) {
      if (habit.targetDate == null) return false;
      return AppDateUtils.isSameDay(habit.targetDate!, selectedDate);
    }).toList();
  });
});
