import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/repositories/habit_repository.dart';

class UpdateHabitUseCase {
  final HabitRepository _habitRepository;

  UpdateHabitUseCase(this._habitRepository);

  Future<void> call(Habit habit) async {
    await _habitRepository.updateHabit(habit);
  }

  Future<void> toggleCompletion(Habit habit) async {
    final updatedHabit = habit.copyWith(isCompleted: !habit.isCompleted);
    await _habitRepository.updateHabit(updatedHabit);
  }
}
