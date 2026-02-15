import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/repositories/habit_repository.dart';

class SetupOnboardingHabitsUseCase {
  final HabitRepository _habitRepository;

  SetupOnboardingHabitsUseCase(this._habitRepository);

  Future<void> call(List<Map<String, dynamic>> selectedHabits) async {
    // Delete all existing habits
    final existingHabits = await _habitRepository.getHabits();
    for (final habit in existingHabits) {
      await _habitRepository.deleteHabit(habit.id);
    }

    // Create new habits from selection
    for (final habitData in selectedHabits) {
      final habit = Habit(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: habitData['name'] as String,
        iconCodePoint: habitData['iconCodePoint'] as int,
        isCompleted: false,
        reminderPeriod: ReminderPeriod.morning,
        targetDate: DateTime.now(),
      );
      await _habitRepository.addHabit(habit);
    }
  }
}
