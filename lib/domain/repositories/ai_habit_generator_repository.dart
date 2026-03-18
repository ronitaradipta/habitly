import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/entities/suggested_habit.dart';

abstract class AiHabitGeneratorRepository {
  Future<List<SuggestedHabit>> generateHabits({
    required String userGoals,
    required List<Habit> existingHabits,
  });
}
