import 'package:habitly/domain/repositories/habit_repository.dart';

class UpdateHabitsReminderUseCase {
  final HabitRepository _habitRepository;

  UpdateHabitsReminderUseCase(this._habitRepository);

  Future<void> call(String reminderTime) async {
    final habits = await _habitRepository.getHabits();

    for (final habit in habits) {
      final updatedHabit = habit.copyWith(
        hasReminder: true,
        reminderTime: reminderTime,
        targetDate: habit.targetDate ?? DateTime.now(),
      );
      await _habitRepository.updateHabit(updatedHabit);
    }
  }
}
