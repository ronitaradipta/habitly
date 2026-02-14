import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/domain/entities/habit.dart';

class HabitFormState {
  final DateTime? selectedDate;
  final ReminderPeriod? selectedPeriod;

  const HabitFormState({this.selectedDate, this.selectedPeriod});

  HabitFormState copyWith({
    DateTime? selectedDate,
    ReminderPeriod? selectedPeriod,
  }) {
    return HabitFormState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
    );
  }
}

class HabitFormNotifier extends Notifier<HabitFormState> {
  @override
  HabitFormState build() => const HabitFormState();

  void selectDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void selectPeriod(ReminderPeriod period) {
    state = state.copyWith(selectedPeriod: period);
  }

  void initFromHabit(Habit habit) {
    state = HabitFormState(
      selectedDate: habit.targetDate,
      selectedPeriod: habit.reminderPeriod,
    );
  }
}

final habitFormProvider =
    NotifierProvider.autoDispose<HabitFormNotifier, HabitFormState>(
      HabitFormNotifier.new,
    );
