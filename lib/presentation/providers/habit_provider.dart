import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/utils/time_utils.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/entities/habit_frequency.dart';
import 'package:habitly/domain/usecases/add_habit_use_case.dart';
import 'package:habitly/domain/usecases/delete_habit_use_case.dart';
import 'package:habitly/domain/usecases/get_habits_use_case.dart';
import 'package:habitly/domain/usecases/setup_onboarding_habits_use_case.dart';
import 'package:habitly/domain/usecases/toggle_habit_completion_use_case.dart';
import 'package:habitly/domain/usecases/update_habit_use_case.dart';
import 'package:habitly/domain/usecases/update_habits_reminder_use_case.dart';
import 'package:habitly/presentation/providers/auth_provider.dart';
import 'package:habitly/presentation/providers/local_notification_provider.dart';
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
  Future<void> _syncLocalReminders(List<Habit> habits) =>
      ref.read(localNotificationServiceProvider).syncHabitReminders(habits);
  Future<void> _clearLocalReminders() =>
      ref.read(localNotificationServiceProvider).cancelAll();

  @override
  Future<List<Habit>> build() async {
    final user = ref.watch(authProvider).asData?.value;
    if (user == null) {
      await _clearLocalReminders();
      return [];
    }

    try {
      final habits = await _getHabitsUseCase();
      await _syncLocalReminders(habits);
      return habits;
    } catch (e, st) {
      debugPrint('Error loading habits: $e');
      state = AsyncValue.error(e, st);
      return [];
    }
  }

  Future<void> addHabit({
    required String name,
    required String iconName,
    required DateTime date,
    bool hasReminder = false,
    TimeOfDay? reminderTime,
    String? categoryId,
    HabitFrequency frequency = HabitFrequency.daily,
    int? customDays,
    DateTime? endDate,
  }) async {
    String? reminderTimeString;
    if (reminderTime != null) {
      reminderTimeString = TimeUtils.formatForStorage(reminderTime);
    }

    state = const AsyncLoading<List<Habit>>();
    state = await AsyncValue.guard(() async {
      await _addHabitUseCase(
        name: name,
        iconName: iconName,
        targetDate: date,
        hasReminder: hasReminder,
        reminderTime: reminderTimeString,
        categoryId: categoryId,
        frequency: frequency,
        customDays: customDays,
        endDate: endDate,
      );
      final habits = await _getHabitsUseCase();
      await _syncLocalReminders(habits);
      return habits;
    });
  }

  Future<void> updateHabit(Habit updatedHabit) async {
    state = await AsyncValue.guard(() async {
      await _updateHabitUseCase(updatedHabit);
      final habits = await _getHabitsUseCase();
      await _syncLocalReminders(habits);
      return habits;
    });
  }

  Future<void> deleteHabit(String habitId) async {
    state = await AsyncValue.guard(() async {
      await _deleteHabitUseCase(habitId);
      final habits = await _getHabitsUseCase();
      await _syncLocalReminders(habits);
      return habits;
    });
  }

  Future<void> toggleCompletion(String habitId, DateTime date) async {
    final currentHabits = state.value;
    if (currentHabits == null) return;

    // save original habit for rollback
    final originalHabit = currentHabits.firstWhere((h) => h.id == habitId);

    // toggle completedDates locally
    final dateKey = Habit.dateKey(date);
    final updatedDates = Map<String, bool>.from(originalHabit.completedDates);
    updatedDates[dateKey] = !(updatedDates[dateKey] ?? false);
    final optimisticHabit = originalHabit.copyWith(
      completedDates: updatedDates,
    );

    // update state directly (not passing through AsyncLoading)
    state = AsyncData(
      currentHabits.map((h) => h.id == habitId ? optimisticHabit : h).toList(),
    );

    // Firestore write in background
    try {
      await _toggleHabitCompletionUseCase(habitId, date);
    } catch (e) {
      // Rollback only failed habit
      final current = state.value;
      if (current != null) {
        state = AsyncData(
          current.map((h) => h.id == habitId ? originalHabit : h).toList(),
        );
      }
      ref
          .read(habitErrorProvider.notifier)
          .setError('Failed to save changes. Please try again.');
    }
  }

  Future<void> setupOnboardingHabits(
    List<OnboardingHabitData> selectedHabits,
  ) async {
    state = const AsyncLoading<List<Habit>>();
    state = await AsyncValue.guard(() async {
      await _setupOnboardingHabitsUseCase(selectedHabits);
      final habits = await _getHabitsUseCase();
      await _syncLocalReminders(habits);
      return habits;
    });
  }

  Future<void> updateHabitsReminder(String reminderTime) async {
    state = await AsyncValue.guard(() async {
      await _updateHabitsReminderUseCase(reminderTime);
      final habits = await _getHabitsUseCase();
      await _syncLocalReminders(habits);
      return habits;
    });
  }

}

final habitProvider = AsyncNotifierProvider<HabitListNotifier, List<Habit>>(
  HabitListNotifier.new,
);

class HabitErrorNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setError(String? error) {
    state = error;
  }
}

final habitErrorProvider = NotifierProvider<HabitErrorNotifier, String?>(
  HabitErrorNotifier.new,
);
