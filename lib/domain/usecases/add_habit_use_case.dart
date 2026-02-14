import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/repositories/habit_repository.dart';

class AddHabitUseCase {
  final HabitRepository _habitRepository;

  AddHabitUseCase(this._habitRepository);

  Future<void> call(Habit habit) async {
    await _habitRepository.addHabit(habit);
  }
}
