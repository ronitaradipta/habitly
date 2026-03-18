import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/entities/suggested_habit.dart';
import 'package:habitly/domain/repositories/ai_habit_generator_repository.dart';

class GenerateHabitsUseCase {
  final AiHabitGeneratorRepository _repository;

  GenerateHabitsUseCase(this._repository);

  Future<List<SuggestedHabit>> call({
    required String userGoals,
    required List<Habit> existingHabits,
  }) =>
      _repository.generateHabits(
        userGoals: userGoals,
        existingHabits: existingHabits,
      );
}
