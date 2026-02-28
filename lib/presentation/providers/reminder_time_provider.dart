import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/constants/reminder_presets.dart';
import 'package:habitly/core/utils/time_utils.dart';

class ReminderTimeState {
  final String? selectedTime; // preset id: 'morning', 'afternoon', 'evening'
  final TimeOfDay? customTime;

  const ReminderTimeState({this.selectedTime, this.customTime});

  bool get hasSelection => selectedTime != null || customTime != null;

  /// Returns the HH:mm time value for the current selection.
  String? get timeValue {
    if (customTime != null) {
      return TimeUtils.formatForStorage(customTime!);
    }
    if (selectedTime != null) {
      return reminderPresetTimes[selectedTime];
    }
    return null;
  }

  /// Returns display-friendly time string.
  String? get displayTime {
    if (customTime != null) {
      return TimeUtils.formatForDisplay(customTime!);
    }
    if (selectedTime != null) {
      return reminderPresetDisplayTimes[selectedTime];
    }
    return null;
  }

  ReminderTimeState copyWith({
    String? selectedTime,
    TimeOfDay? customTime,
    bool clearCustom = false,
    bool clearPreset = false,
  }) {
    return ReminderTimeState(
      selectedTime: clearPreset ? null : (selectedTime ?? this.selectedTime),
      customTime: clearCustom ? null : (customTime ?? this.customTime),
    );
  }
}

class ReminderTimeNotifier extends Notifier<ReminderTimeState> {
  @override
  ReminderTimeState build() => const ReminderTimeState();

  void selectTime(String timeId) {
    state = ReminderTimeState(selectedTime: timeId);
  }

  void setCustomTime(TimeOfDay time) {
    state = ReminderTimeState(customTime: time);
  }

  void clearSelection() {
    state = const ReminderTimeState();
  }
}

final reminderTimeProvider =
    NotifierProvider.autoDispose<ReminderTimeNotifier, ReminderTimeState>(
      ReminderTimeNotifier.new,
    );
