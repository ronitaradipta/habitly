import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/usecases/add_habit_use_case.dart';
import 'package:habitly/domain/usecases/delete_habit_use_case.dart';
import 'package:habitly/domain/usecases/get_habits_use_case.dart';
import 'package:habitly/domain/usecases/setup_onboarding_habits_use_case.dart';
import 'package:habitly/domain/usecases/toggle_habit_completion_use_case.dart';
import 'package:habitly/domain/usecases/update_habit_use_case.dart';
import 'package:habitly/domain/usecases/update_habits_reminder_use_case.dart';
import 'package:habitly/presentation/providers/auth_provider.dart';
import 'package:habitly/presentation/providers/use_case_providers.dart';

class HabitListNotifier extends AsyncNotifier<List<Habit>> {
  AddHabitUseCase get _addHabitUseCase => ref.read(addHabitUseCaseProvider);
  GetHabitsUseCase get _getHabitsUseCase => ref.read(getHabitsUseCaseProvider);
  UpdateHabitUseCase get _updateHabitUseCase =>
      ref.read(updateHabitUseCaseProvider);
  DeleteHabitUseCase get _deleteHabitUseCase =>
      ref.read(deleteHabitUseCaseProvider);
  SetupOnboardingHabitsUseCase get _setupOnboardingHabitsUseCase =>
      ref.read(setupOnboardingHabitsUseCaseProvider);
  UpdateHabitsReminderUseCase get _updateHabitsReminderUseCase =>
      ref.read(updateHabitsReminderUseCaseProvider);
  ToggleHabitCompletionUseCase get _toggleHabitCompletionUseCase =>
      ref.read(toggleHabitCompletionUseCaseProvider);

  @override
  Future<List<Habit>> build() async {
    final user = ref.watch(authProvider).asData?.value;
    if (user == null) return [];

    try {
      return await _getHabitsUseCase();
    } catch (e, st) {
      debugPrint('Error loading habits: $e');
      state = AsyncValue.error(e, st);
      return [];
    }
  }

  Future<void> addHabit({
    required String name,
    required int iconCodePoint,
    required DateTime date,
    required ReminderPeriod period,
  }) async {
    state = await AsyncValue.guard(() async {
      await _addHabitUseCase(
        name: name,
        iconCodePoint: iconCodePoint,
        targetDate: date,
        reminderPeriod: period,
      );
      return _getHabitsUseCase();
    });
  }

  Future<void> updateHabit(Habit updatedHabit) async {
    state = await AsyncValue.guard(() async {
      await _updateHabitUseCase(updatedHabit);
      return _getHabitsUseCase();
    });
  }

  Future<void> deleteHabit(String habitId) async {
    state = await AsyncValue.guard(() async {
      await _deleteHabitUseCase(habitId);
      return _getHabitsUseCase();
    });
  }

  Future<void> toggleCompletion(String habitId) async {
    state = await AsyncValue.guard(() async {
      await _toggleHabitCompletionUseCase(habitId);
      return _getHabitsUseCase();
    });
  }

  Future<void> setupOnboardingHabits(
    List<Map<String, dynamic>> selectedHabits,
  ) async {
    state = await AsyncValue.guard(() async {
      await _setupOnboardingHabitsUseCase(selectedHabits);
      return _getHabitsUseCase();
    });
  }

  Future<void> updateHabitsReminder(ReminderPeriod period) async {
    state = await AsyncValue.guard(() async {
      await _updateHabitsReminderUseCase(period);
      return _getHabitsUseCase();
    });
  }
}

final habitProvider = AsyncNotifierProvider<HabitListNotifier, List<Habit>>(
  HabitListNotifier.new,
);
