import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/repositories/habit_repository.dart';

class AddHabitUseCase {
  final HabitRepository _habitRepository;

  AddHabitUseCase(this._habitRepository);

  Future<void> call({
    required String name,
    required int iconCodePoint,
    required DateTime targetDate,
    required ReminderPeriod reminderPeriod,
  }) async {
    final habit = Habit(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      iconCodePoint: iconCodePoint,
      isCompleted: false,
      completionTime: reminderPeriod.time,
      reminderPeriod: reminderPeriod,
      targetDate: targetDate,
    );
    await _habitRepository.addHabit(habit);
  }
}
