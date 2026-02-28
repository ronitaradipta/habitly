import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/constants/reminder_presets.dart';
import 'package:habitly/core/utils/time_utils.dart';

class ReminderTimeState {
  final String? selectedTime; // preset id: 'morning', 'afternoon', 'evening'
  final TimeOfDay? customTime;
  final bool isLoading;

  const ReminderTimeState({
    this.selectedTime,
    this.customTime,
    this.isLoading = false,
  });

  bool get hasSelection => selectedTime != null || customTime != null;

  ReminderPreset? get _selectedPreset {
    if (selectedTime == null) return null;
    return reminderPresets.where((p) => p.id == selectedTime).firstOrNull;
  }

  /// Returns the HH:mm time value for the current selection.
  String? get timeValue {
    if (customTime != null) {
      return TimeUtils.formatForStorage(customTime!);
    }
    return _selectedPreset?.timeValue;
  }

  /// Returns display-friendly time string.
  String? get displayTime {
    if (customTime != null) {
      return TimeUtils.formatForDisplay(customTime!);
    }
    return _selectedPreset?.displayTime;
  }

  ReminderTimeState copyWith({
    String? selectedTime,
    TimeOfDay? customTime,
    bool clearCustom = false,
    bool clearPreset = false,
    bool? isLoading,
  }) {
    return ReminderTimeState(
      selectedTime: clearPreset ? null : (selectedTime ?? this.selectedTime),
      customTime: clearCustom ? null : (customTime ?? this.customTime),
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ReminderTimeNotifier extends Notifier<ReminderTimeState> {
  @override
  ReminderTimeState build() => const ReminderTimeState();

  void selectTime(String timeId) {
    state = state.copyWith(selectedTime: timeId, clearCustom: true);
  }

  void setCustomTime(TimeOfDay time) {
    state = state.copyWith(customTime: time, clearPreset: true);
  }

  void clearSelection() {
    state = state.copyWith(clearCustom: true, clearPreset: true);
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }
}

final reminderTimeProvider =
    NotifierProvider.autoDispose<ReminderTimeNotifier, ReminderTimeState>(
      ReminderTimeNotifier.new,
    );
