import 'package:habitly/domain/repositories/habit_repository.dart';

class DeleteHabitUseCase {
  final HabitRepository _habitRepository;

  DeleteHabitUseCase(this._habitRepository);

  Future<void> call(String habitId) async {
    await _habitRepository.deleteHabit(habitId);
  }
}
