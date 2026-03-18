import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/entities/habit_frequency.dart';
import 'package:habitly/domain/entities/suggested_habit.dart';
import 'package:habitly/domain/usecases/generate_habits_use_case.dart';
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

    final results = await _useCase(
      userGoals: goals,
      existingHabits: habits,
    );

    if (results.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        error: 'Could not generate habits. Please try again.',
      );
    } else {
      state = state.copyWith(
        suggestions: results,
        selectedIndices: {},
        isLoading: false,
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

    for (final index in state.selectedIndices) {
      final suggestion = state.suggestions[index];
      final freq = HabitFrequency.fromName(suggestion.frequency);

      await notifier.addHabit(
        name: suggestion.name,
        iconName: suggestion.iconName,
        date: now,
        categoryId: suggestion.categoryId,
        frequency: freq,
      );
    }

    state = state.copyWith(
      suggestions: [],
      selectedIndices: {},
      isAdding: false,
      addedCount: state.selectedIndices.length,
    );
  }

  void reset() {
    state = const AiHabitGeneratorState();
  }
}

final aiHabitGeneratorProvider =
    NotifierProvider<AiHabitGeneratorNotifier, AiHabitGeneratorState>(
  AiHabitGeneratorNotifier.new,
);
