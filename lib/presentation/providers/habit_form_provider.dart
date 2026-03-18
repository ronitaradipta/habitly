import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/utils/habit_validators.dart';
import 'package:habitly/core/utils/time_utils.dart';
import 'package:habitly/domain/entities/category.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/entities/habit_frequency.dart';
import 'package:habitly/presentation/providers/habit_provider.dart';

enum FormMode { create, edit }

enum SaveResult { none, created, updated, validationError }

// Wrapper to differentiate "not passed" vs "intentionally set to null"
class Nullable<T> {
  final T? value;
  const Nullable(this.value);
}

class HabitFormState {
  final String? name;
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
  final SaveResult saveResult;
  final String? validationError;

  const HabitFormState({
    this.name,
    this.selectedDate,
    this.selectedFrequency,
    this.customDays,
    this.endDate,
    this.hasReminder = false,
    this.reminderTime,
    this.selectedCategory,
    this.isSaving = false,
    this.saveResult = SaveResult.none,
    this.validationError,
  });

  HabitFormState copyWith({
    String? name,
    DateTime? selectedDate,
    HabitFrequency? selectedFrequency,
    int? customDays,
    Nullable<DateTime>? endDate,
    bool? hasReminder,
    Nullable<TimeOfDay>? reminderTime,
    Nullable<HabitCategory>? selectedCategory,
    bool? isSaving,
    SaveResult? saveResult,
    Nullable<String>? validationError,
  }) {
    return HabitFormState(
      name: name ?? this.name,
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
      saveResult: saveResult ?? this.saveResult,
      validationError: validationError != null
          ? validationError.value
          : this.validationError,
    );
  }
}

class HabitFormNotifier extends Notifier<HabitFormState> {
  final Habit? _initialHabit;

  HabitFormNotifier([this._initialHabit]);

  @override
  HabitFormState build() {
    final habit = _initialHabit;
    if (habit != null) {
      return HabitFormState(
        name: habit.name,
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
    return const HabitFormState();
  }

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

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void setSaving(bool saving) {
    state = state.copyWith(isSaving: saving);
  }

  Future<void> saveHabit(FormMode mode, Habit? initialHabit) async {
    final nameResult = HabitValidators.validateHabitName(state.name ?? '');
    if (!nameResult.isValid) {
      state = state.copyWith(
        saveResult: SaveResult.validationError,
        validationError: Nullable(nameResult.errorMessage ?? 'Validation failed'),
      );
      return;
    }

    final dateResult = HabitValidators.validateHabitDate(state.selectedDate);
    if (!dateResult.isValid) {
      state = state.copyWith(
        saveResult: SaveResult.validationError,
        validationError: Nullable(dateResult.errorMessage ?? 'Validation failed'),
      );
      return;
    }

    final endDateResult = HabitValidators.validateEndDate(
      state.endDate,
      state.selectedDate,
    );
    if (!endDateResult.isValid) {
      state = state.copyWith(
        saveResult: SaveResult.validationError,
        validationError: Nullable(endDateResult.errorMessage ?? 'Validation failed'),
      );
      return;
    }

    state = state.copyWith(isSaving: true);

    try {
      final notifier = ref.read(habitProvider.notifier);

      if (mode == FormMode.create) {
        final iconName = state.selectedCategory?.iconName ?? 'fitness_center';

        await notifier.addHabit(
          name: state.name ?? '',
          iconName: iconName,
          date: state.selectedDate!,
          hasReminder: state.hasReminder,
          reminderTime: state.reminderTime,
          categoryId: state.selectedCategory?.id,
          frequency: state.selectedFrequency ?? HabitFrequency.daily,
          customDays: state.customDays,
          endDate: state.endDate,
        );

        state = state.copyWith(isSaving: false, saveResult: SaveResult.created);
      } else {
        if (initialHabit == null) return;

        final updatedHabit = initialHabit.copyWith(
          name: state.name ?? '',
          targetDate: state.selectedDate,
          hasReminder: state.hasReminder,
          reminderTime: state.reminderTime != null
              ? TimeUtils.formatForStorage(state.reminderTime!)
              : null,
          categoryId: state.selectedCategory?.id,
          frequency: state.selectedFrequency ?? HabitFrequency.daily,
          customDays: state.customDays,
          endDate: state.endDate,
        );

        await notifier.updateHabit(updatedHabit);

        state = state.copyWith(isSaving: false, saveResult: SaveResult.updated);
      }
    } catch (_) {
      state = state.copyWith(isSaving: false);
    }
  }
}

final habitFormProvider =
    NotifierProvider.autoDispose<HabitFormNotifier, HabitFormState>(
      HabitFormNotifier.new,
    );
