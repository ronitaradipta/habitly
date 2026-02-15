import 'package:habitly/domain/repositories/habit_repository.dart';

class ToggleHabitCompletionUseCase {
  final HabitRepository _habitRepository;

  ToggleHabitCompletionUseCase(this._habitRepository);

  Future<void> call(String habitId) async {
    final habit = await _habitRepository.getHabitById(habitId);
    if (habit == null) return;

    final toggled = habit.copyWith(isCompleted: !habit.isCompleted);
    await _habitRepository.updateHabit(toggled);
  }
}
