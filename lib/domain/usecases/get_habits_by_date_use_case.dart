import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/repositories/habit_repository.dart';

class GetHabitsByDateUseCase {
  final HabitRepository _habitRepository;

  GetHabitsByDateUseCase(this._habitRepository);

  Future<List<Habit>> call(DateTime date) async {
    return _habitRepository.getHabitsByDate(date);
  }
}
