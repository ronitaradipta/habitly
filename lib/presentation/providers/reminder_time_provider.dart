import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReminderTimeState {
  final String? selectedTime;

  const ReminderTimeState({this.selectedTime});

  bool get hasSelection => selectedTime != null;
  bool get canProceed => hasSelection;

  ReminderTimeState copyWith({
    String? selectedTime,
    bool clearSelection = false,
  }) {
    return ReminderTimeState(
      selectedTime: clearSelection ? null : (selectedTime ?? this.selectedTime),
    );
  }
}

class ReminderTimeNotifier extends Notifier<ReminderTimeState> {
  @override
  ReminderTimeState build() => const ReminderTimeState();

  void selectTime(String timeId) {
    state = state.copyWith(selectedTime: timeId);
  }

  void clearSelection() {
    state = state.copyWith(clearSelection: true);
  }
}

final reminderTimeProvider =
    NotifierProvider<ReminderTimeNotifier, ReminderTimeState>(
      ReminderTimeNotifier.new,
    );
