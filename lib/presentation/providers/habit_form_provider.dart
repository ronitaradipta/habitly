import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/utils/time_utils.dart';
import 'package:habitly/domain/entities/category.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/entities/habit_frequency.dart';

// Wrapper to differentiate "not passed" vs "intentionally set to null"
class Nullable<T> {
  final T? value;
  const Nullable(this.value);
}

class HabitFormState {
  final DateTime? selectedDate;
  final HabitFrequency? selectedFrequency;
  final int? customDays;
  final DateTime? endDate;

  // Reminder fields
  final bool hasReminder;
  final TimeOfDay? reminderTime;

  // Category
  final HabitCategory? selectedCategory;

  // Saving state
  final bool isSaving;

  const HabitFormState({
    this.selectedDate,
    this.selectedFrequency,
    this.customDays,
    this.endDate,
    this.hasReminder = false,
    this.reminderTime,
    this.selectedCategory,
    this.isSaving = false,
  });

  HabitFormState copyWith({
    DateTime? selectedDate,
    HabitFrequency? selectedFrequency,
    int? customDays,
    Nullable<DateTime>? endDate,
    bool? hasReminder,
    Nullable<TimeOfDay>? reminderTime,
    Nullable<HabitCategory>? selectedCategory,
    bool? isSaving,
  }) {
    return HabitFormState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedFrequency: selectedFrequency ?? this.selectedFrequency,
      customDays: customDays ?? this.customDays,
      endDate: endDate != null ? endDate.value : this.endDate,
      hasReminder: hasReminder ?? this.hasReminder,
      reminderTime: reminderTime != null
          ? reminderTime.value
          : this.reminderTime,
      selectedCategory: selectedCategory != null
          ? selectedCategory.value
          : this.selectedCategory,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class HabitFormNotifier extends Notifier<HabitFormState> {
  @override
  HabitFormState build() => const HabitFormState();

  void selectDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void selectFrequency(HabitFrequency frequency) {
    state = state.copyWith(selectedFrequency: frequency);
  }

  void setCustomDays(int days) {
    state = state.copyWith(customDays: days);
  }

  void setEndDate(DateTime? date) {
    state = state.copyWith(endDate: Nullable(date));
  }

  // Reminder methods
  void setReminder(bool enabled) {
    state = state.copyWith(hasReminder: enabled);
  }

  void setReminderTime(TimeOfDay time) {
    state = state.copyWith(reminderTime: Nullable(time), hasReminder: true);
  }

  void clearReminder() {
    state = state.copyWith(
      hasReminder: false,
      reminderTime: const Nullable(null),
    );
  }

  // Category methods
  void setCategory(HabitCategory category) {
    state = state.copyWith(selectedCategory: Nullable(category));
  }

  void clearCategory() {
    state = state.copyWith(selectedCategory: const Nullable(null));
  }

  void initFromHabit(Habit habit) {
    state = HabitFormState(
      selectedDate: habit.targetDate,
      selectedFrequency: habit.frequency,
      customDays: habit.customDays,
      endDate: habit.endDate,
      hasReminder: habit.hasReminder,
      reminderTime: habit.reminderTime != null
          ? TimeUtils.parse(habit.reminderTime!)
          : null,
      selectedCategory: habit.category,
    );
  }

  void setSaving(bool saving) {
    state = state.copyWith(isSaving: saving);
  }
}

final habitFormProvider =
    NotifierProvider.autoDispose<HabitFormNotifier, HabitFormState>(
      HabitFormNotifier.new,
    );
