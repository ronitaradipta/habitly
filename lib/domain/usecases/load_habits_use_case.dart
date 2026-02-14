import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/repositories/habit_repository.dart';

class LoadHabitsUseCase {
  final HabitRepository _habitRepository;

  LoadHabitsUseCase(this._habitRepository);

  Future<List<Habit>> call() async {
    await _habitRepository.loadFromStorage();
    return _habitRepository.getHabits();
  }
}
