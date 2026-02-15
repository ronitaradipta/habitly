import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/repositories/habit_repository.dart';

class UpdateHabitsReminderUseCase {
  final HabitRepository _habitRepository;

  UpdateHabitsReminderUseCase(this._habitRepository);

  Future<void> call(ReminderPeriod period) async {
    final habits = await _habitRepository.getHabits();

    for (final habit in habits) {
      final updatedHabit = Habit(
        id: habit.id,
        name: habit.name,
        iconCodePoint: habit.iconCodePoint,
        isCompleted: habit.isCompleted,
        completionTime: period.time,
        reminderPeriod: period,
        targetDate: habit.targetDate ?? DateTime.now(),
      );
      await _habitRepository.updateHabit(updatedHabit);
    }
  }
}
