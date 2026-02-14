import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/repositories/habit_repository.dart';

class GetHabitsUseCase {
  final HabitRepository _habitRepository;

  GetHabitsUseCase(this._habitRepository);

  Future<List<Habit>> call() async {
    return _habitRepository.getHabits();
  }

  Future<List<Habit>> byDate(DateTime date) async {
    return _habitRepository.getHabitsByDate(date);
  }

  Future<Habit?> byId(String id) async {
    return _habitRepository.getHabitById(id);
  }
}
