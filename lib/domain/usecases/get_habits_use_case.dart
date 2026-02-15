import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/repositories/habit_repository.dart';

class GetHabitsUseCase {
  final HabitRepository _habitRepository;

  GetHabitsUseCase(this._habitRepository);

  Future<List<Habit>> call() async {
    return _habitRepository.getHabits();
  }
}
