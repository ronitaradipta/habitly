import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/usecases/add_habit_use_case.dart';
import 'package:habitly/domain/usecases/delete_habit_use_case.dart';
import 'package:habitly/domain/usecases/get_habits_use_case.dart';
import 'package:habitly/domain/usecases/load_habits_use_case.dart';
import 'package:habitly/domain/usecases/update_habit_use_case.dart';
import 'package:habitly/presentation/providers/auth_provider.dart';
import 'package:habitly/injection_container.dart' as di;

class HabitListState {
  final List<Habit> habits;
  final bool isLoading;
  final String? error;

  const HabitListState({
    this.habits = const [],
    this.isLoading = false,
    this.error,
  });

  HabitListState copyWith({
    List<Habit>? habits,
    bool? isLoading,
    String? error,
  }) {
    return HabitListState(
      habits: habits ?? this.habits,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class HabitListNotifier extends AsyncNotifier<List<Habit>> {
  HabitListNotifier(this.userEmail);
  final String userEmail;

  late final AddHabitUseCase _addHabitUseCase = di.getIt<AddHabitUseCase>(
    param1: userEmail,
  );
  late final GetHabitsUseCase _getHabitsUseCase = di.getIt<GetHabitsUseCase>(
    param1: userEmail,
  );
  late final UpdateHabitUseCase _updateHabitUseCase = di
      .getIt<UpdateHabitUseCase>(param1: userEmail);
  late final DeleteHabitUseCase _deleteHabitUseCase = di
      .getIt<DeleteHabitUseCase>(param1: userEmail);
  late final LoadHabitsUseCase _loadHabitsUseCase = di.getIt<LoadHabitsUseCase>(
    param1: userEmail,
  );

  @override
  Future<List<Habit>> build() async {
    try {
      return await _loadHabitsUseCase();
    } catch (e, st) {
      debugPrint('Error loading habits: $e');
      state = AsyncValue.error(e, st);
      return [];
    }
  }

  Future<void> addHabit({
    required String name,
    required DateTime date,
    required ReminderPeriod period,
  }) async {
    state = await AsyncValue.guard(() async {
      final habit = Habit(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        iconCodePoint: Icons.fitness_center.codePoint, // default icon
        isCompleted: false,
        completionTime: period.time,
        reminderPeriod: period,
        targetDate: date,
      );

      await _addHabitUseCase(habit);
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
    final currentHabits = state.value ?? [];
    final habit = currentHabits.firstWhere((h) => h.id == habitId);
    await updateHabit(habit.copyWith(isCompleted: !habit.isCompleted));
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

final habitByIdProvider = Provider.family<Habit?, String>((ref, habitId) {
  final email = ref.watch(currentUserEmailProvider);
  if (email == null) return null;
  final habitsAsync = ref.watch(habitProvider(email));
  final habits = habitsAsync.value ?? [];

  for (final habit in habits) {
    if (habit.id == habitId) {
      return habit;
    }
  }
  return null;
});

class HabitSelectionState {
  final Set<String> selectedHabits;

  const HabitSelectionState({this.selectedHabits = const {}});

  bool get hasSelection => selectedHabits.isNotEmpty;
  bool get canProceed => hasSelection;

  bool isSelected(String habitId) => selectedHabits.contains(habitId);

  HabitSelectionState copyWith({Set<String>? selectedHabits}) {
    return HabitSelectionState(
      selectedHabits: selectedHabits ?? this.selectedHabits,
    );
  }
}

class HabitSelectionNotifier extends Notifier<HabitSelectionState> {
  @override
  HabitSelectionState build() {
    return const HabitSelectionState();
  }

  void toggleHabit(String habitId) {
    final currentSelection = Set<String>.from(state.selectedHabits);
    if (currentSelection.contains(habitId)) {
      currentSelection.remove(habitId);
    } else {
      currentSelection.add(habitId);
    }
    state = state.copyWith(selectedHabits: currentSelection);
  }

  void clearSelections() {
    state = const HabitSelectionState();
  }
}

final habitSelectionProvider =
    NotifierProvider<HabitSelectionNotifier, HabitSelectionState>(
      HabitSelectionNotifier.new,
    );
