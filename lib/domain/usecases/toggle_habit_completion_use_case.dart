import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/repositories/habit_repository.dart';

class ToggleHabitCompletionUseCase {
  final HabitRepository _habitRepository;

  ToggleHabitCompletionUseCase(this._habitRepository);

  Future<void> call(String habitId, DateTime date) async {
    final habit = await _habitRepository.getHabitById(habitId);
    if (habit == null) return;

    final key = Habit.dateKey(date);
    final currentStatus = habit.completedDates[key] == true;
    final newDates = Map<String, bool>.from(habit.completedDates);
    newDates[key] = !currentStatus;

    final toggled = habit.copyWith(
      completedDates: newDates,
    );
    await _habitRepository.updateHabit(toggled);
  }
}
