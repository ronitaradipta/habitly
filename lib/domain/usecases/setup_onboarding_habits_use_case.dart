import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/entities/habit_frequency.dart';
import 'package:habitly/domain/repositories/habit_repository.dart';

class OnboardingHabitData {
  final String name;
  final String iconName;
  final String? categoryId;

  const OnboardingHabitData({
    required this.name,
    required this.iconName,
    this.categoryId,
  });
}

class SetupOnboardingHabitsUseCase {
  final HabitRepository _habitRepository;

  SetupOnboardingHabitsUseCase(this._habitRepository);

  Future<void> call(List<OnboardingHabitData> selectedHabits) async {
    // Delete all existing habits
    final existingHabits = await _habitRepository.getHabits();
    for (final habit in existingHabits) {
      await _habitRepository.deleteHabit(habit.id);
    }

    // Create new habits from selection
    for (final habitData in selectedHabits) {
      final habit = Habit(
        id: '',
        name: habitData.name,
        iconName: habitData.iconName,
        targetDate: DateTime.now(),
        frequency: HabitFrequency.daily,
        categoryId: habitData.categoryId,
      );
      await _habitRepository.addHabit(habit);
    }
  }
}
