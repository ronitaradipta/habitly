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
  HabitListNotifier(this.userEmail);
  final String userEmail;

  late final AddHabitUseCase _addHabitUseCase;
  late final GetHabitsUseCase _getHabitsUseCase;
  late final UpdateHabitUseCase _updateHabitUseCase;
  late final DeleteHabitUseCase _deleteHabitUseCase;
  late final SetupOnboardingHabitsUseCase _setupOnboardingHabitsUseCase;
  late final UpdateHabitsReminderUseCase _updateHabitsReminderUseCase;
  late final ToggleHabitCompletionUseCase _toggleHabitCompletionUseCase;

  @override
  Future<List<Habit>> build() async {
    _addHabitUseCase = ref.read(addHabitUseCaseProvider(userEmail));
    _getHabitsUseCase = ref.read(getHabitsUseCaseProvider(userEmail));
    _updateHabitUseCase = ref.read(updateHabitUseCaseProvider(userEmail));
    _deleteHabitUseCase = ref.read(deleteHabitUseCaseProvider(userEmail));
    _setupOnboardingHabitsUseCase = ref.read(
      setupOnboardingHabitsUseCaseProvider(userEmail),
    );
    _updateHabitsReminderUseCase = ref.read(
      updateHabitsReminderUseCaseProvider(userEmail),
    );
    _toggleHabitCompletionUseCase = ref.read(
      toggleHabitCompletionUseCaseProvider(userEmail),
    );

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

final habitProvider =
    AsyncNotifierProvider.family<HabitListNotifier, List<Habit>, String>(
      (userEmail) => HabitListNotifier(userEmail),
    );

final currentUserHabitsNotifierProvider = Provider<HabitListNotifier?>((ref) {
  final email = ref.watch(currentUserEmailProvider);
  if (email == null) return null;
  return ref.read(habitProvider(email).notifier);
});
