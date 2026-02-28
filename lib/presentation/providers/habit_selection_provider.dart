import 'package:flutter_riverpod/flutter_riverpod.dart';

class HabitSelectionState {
  final Set<String> selectedHabits;

  const HabitSelectionState({this.selectedHabits = const {}});

  bool get hasSelection => selectedHabits.isNotEmpty;

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
}

final habitSelectionProvider =
    NotifierProvider.autoDispose<HabitSelectionNotifier, HabitSelectionState>(
      HabitSelectionNotifier.new,
    );
