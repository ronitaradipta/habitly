import 'package:habitly/core/services/ai_habit_generator_service.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/entities/suggested_habit.dart';
import 'package:habitly/domain/repositories/ai_habit_generator_repository.dart';

class GroqAiHabitGeneratorRepository implements AiHabitGeneratorRepository {
  final AiHabitGeneratorService _service;

  GroqAiHabitGeneratorRepository(this._service);

  @override
  Future<List<SuggestedHabit>> generateHabits({
    required String userGoals,
    required List<Habit> existingHabits,
  }) =>
      _service.generateHabits(
        userGoals: userGoals,
        existingHabits: existingHabits,
      );
}
