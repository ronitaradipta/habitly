import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/entities/habit_frequency.dart';
import 'package:habitly/domain/entities/suggested_habit.dart';
import 'package:habitly/domain/usecases/generate_habits_use_case.dart';
import 'package:habitly/core/constants/app_constants.dart';
import 'package:habitly/presentation/providers/habit_provider.dart';
import 'package:habitly/presentation/providers/use_case_providers.dart';

class AiHabitGeneratorState {
  final List<SuggestedHabit> suggestions;
  final Set<int> selectedIndices;
  final bool isLoading;
  final bool isAdding;
  final String? error;
  final int? addedCount;

  const AiHabitGeneratorState({
    this.suggestions = const [],
    this.selectedIndices = const {},
    this.isLoading = false,
    this.isAdding = false,
    this.error,
    this.addedCount,
  });

  AiHabitGeneratorState copyWith({
    List<SuggestedHabit>? suggestions,
    Set<int>? selectedIndices,
    bool? isLoading,
    bool? isAdding,
    String? error,
    int? addedCount,
  }) =>
      AiHabitGeneratorState(
        suggestions: suggestions ?? this.suggestions,
        selectedIndices: selectedIndices ?? this.selectedIndices,
        isLoading: isLoading ?? this.isLoading,
        isAdding: isAdding ?? this.isAdding,
        error: error,
        addedCount: addedCount,
      );
}

class AiHabitGeneratorNotifier extends Notifier<AiHabitGeneratorState> {
  GenerateHabitsUseCase get _useCase =>
      ref.read(generateHabitsUseCaseProvider);

  @override
  AiHabitGeneratorState build() => const AiHabitGeneratorState();

  Future<void> generate(String goals) async {
    state = state.copyWith(isLoading: true, error: null);

    final habits = ref.read(habitProvider).value ?? <Habit>[];

    try {
      final results = await _useCase(
        userGoals: goals,
        existingHabits: habits,
      ).timeout(AppTimeouts.aiGeneration);

      if (results.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          error: AppErrorMessages.generateFailed,
        );
      } else {
        state = state.copyWith(
          suggestions: results,
          selectedIndices: {},
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e is TimeoutException
            ? AppErrorMessages.timeout
            : AppErrorMessages.generateFailed,
      );
    }
  }

  void toggleSelection(int index) {
    final current = Set<int>.from(state.selectedIndices);
    if (current.contains(index)) {
      current.remove(index);
    } else {
      current.add(index);
    }
    state = state.copyWith(selectedIndices: current);
  }

  Future<void> addSelectedHabits() async {
    state = state.copyWith(isAdding: true);

    final notifier = ref.read(habitProvider.notifier);
    final now = DateTime.now();

    try {
      final futures = state.selectedIndices.map((index) {
        final suggestion = state.suggestions[index];
        final freq = HabitFrequency.fromName(suggestion.frequency);
        return notifier.addHabit(
          name: suggestion.name,
          iconName: suggestion.iconName,
          date: now,
          categoryId: suggestion.categoryId,
          frequency: freq,
        ).timeout(AppTimeouts.habitWrite);
      });
      await Future.wait(futures);

      state = state.copyWith(
        suggestions: [],
        selectedIndices: {},
        isAdding: false,
        addedCount: state.selectedIndices.length,
      );
    } catch (e) {
      state = state.copyWith(
        isAdding: false,
        error: e is TimeoutException
            ? AppErrorMessages.timeout
            : AppErrorMessages.saveFailed,
      );
    }
  }

  void reset() {
    state = const AiHabitGeneratorState();
  }
}

final aiHabitGeneratorProvider =
    NotifierProvider<AiHabitGeneratorNotifier, AiHabitGeneratorState>(
  AiHabitGeneratorNotifier.new,
);
