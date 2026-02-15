import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReminderTimeState {
  final String? selectedTime;

  const ReminderTimeState({this.selectedTime});

  bool get hasSelection => selectedTime != null;

  ReminderTimeState copyWith({String? selectedTime}) {
    return ReminderTimeState(selectedTime: selectedTime ?? this.selectedTime);
  }
}

class ReminderTimeNotifier extends Notifier<ReminderTimeState> {
  @override
  ReminderTimeState build() => const ReminderTimeState();

  void selectTime(String timeId) {
    state = state.copyWith(selectedTime: timeId);
  }
}

final reminderTimeProvider =
    NotifierProvider<ReminderTimeNotifier, ReminderTimeState>(
      ReminderTimeNotifier.new,
    );
