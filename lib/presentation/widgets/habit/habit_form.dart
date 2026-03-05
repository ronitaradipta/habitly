import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:habitly/core/utils/time_utils.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/presentation/widgets/shared/form_row_selector.dart';
import 'package:habitly/core/utils/habit_validators.dart';
import 'package:habitly/presentation/widgets/shared/buttons/app_button.dart';
import 'package:habitly/presentation/widgets/shared/buttons/theme_switch_button.dart';
import 'package:habitly/presentation/widgets/shared/inputs/app_text_field.dart';
import 'package:habitly/domain/entities/habit_frequency.dart';
import 'package:habitly/presentation/widgets/habit/frequency_selector.dart';
import 'package:habitly/presentation/widgets/habit/reminder_selector.dart';
import 'package:habitly/presentation/widgets/habit/category_selector.dart';
import 'package:habitly/presentation/providers/habit_form_provider.dart';
import 'package:habitly/presentation/providers/habit_provider.dart';
import 'package:habitly/presentation/widgets/shared/theme_scaffold.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:sizer/sizer.dart';

enum FormMode { create, edit }

class HabitForm extends StatelessWidget {
  final FormMode mode;
  final Habit? initialHabit;
  final VoidCallback? onDelete;

  const HabitForm({
    super.key,
    required this.mode,
    this.initialHabit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        habitFormProvider.overrideWith(() => HabitFormNotifier(initialHabit)),
      ],
      child: _HabitFormBody(
        mode: mode,
        initialHabit: initialHabit,
        onDelete: onDelete,
      ),
    );
  }
}

class _HabitFormBody extends ConsumerWidget {
  final FormMode mode;
  final Habit? initialHabit;
  final VoidCallback? onDelete;

  static final _dateFormat = DateFormat('MM/dd/yyyy');

  const _HabitFormBody({
    required this.mode,
    this.initialHabit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final formState = ref.watch(habitFormProvider);
    final title = mode == FormMode.create ? 'Add New Habit' : 'Edit Habit';
    final buttonText = mode == FormMode.create ? 'Save Habit' : 'Update Habit';
    final isLoading = formState.isSaving;

    final dateText = formState.selectedDate != null
        ? _dateFormat.format(formState.selectedDate!)
        : 'Select date';

    Future<void> selectDate() async {
      final current = ref.read(habitFormProvider);
      final picked = await showDatePicker(
        context: context,
        initialDate: current.selectedDate ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      );
      if (picked != null) {
        ref.read(habitFormProvider.notifier).selectDate(picked);
      }
    }

    Future<void> selectEndDate() async {
      final current = ref.read(habitFormProvider);
      final startDate = current.selectedDate ?? DateTime.now();
      final picked = await showDatePicker(
        context: context,
        initialDate: current.endDate ?? startDate,
        firstDate: startDate,
        lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      );
      if (picked != null) {
        ref.read(habitFormProvider.notifier).setEndDate(picked);
      }
    }

    void showValidationError(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    Future<void> saveHabit() async {
      final fs = ref.read(habitFormProvider);

      final nameResult = HabitValidators.validateHabitName(fs.name ?? '');
      if (!nameResult.isValid) {
        showValidationError(nameResult.errorMessage ?? 'Validation failed');
        return;
      }

      final dateResult = HabitValidators.validateHabitDate(fs.selectedDate);
      if (!dateResult.isValid) {
        showValidationError(dateResult.errorMessage ?? 'Validation failed');
        return;
      }

      final endDateResult = HabitValidators.validateEndDate(
        fs.endDate,
        fs.selectedDate,
      );
      if (!endDateResult.isValid) {
        showValidationError(endDateResult.errorMessage ?? 'Validation failed');
        return;
      }

      ref.read(habitFormProvider.notifier).setSaving(true);

      try {
        final notifier = ref.read(habitProvider.notifier);

        if (mode == FormMode.create) {
          final iconName = fs.selectedCategory?.iconName ?? 'fitness_center';

          await notifier.addHabit(
            name: fs.name ?? '',
            iconName: iconName,
            date: fs.selectedDate!,
            hasReminder: fs.hasReminder,
            reminderTime: fs.reminderTime,
            categoryId: fs.selectedCategory?.id,
            frequency: fs.selectedFrequency ?? HabitFrequency.daily,
            customDays: fs.customDays,
            endDate: fs.endDate,
          );

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Habit added successfully!')),
            );
            Navigator.pop(context);
          }
        } else {
          if (initialHabit == null) return;

          final updatedHabit = initialHabit!.copyWith(
            name: fs.name ?? '',
            targetDate: fs.selectedDate,
            hasReminder: fs.hasReminder,
            reminderTime: fs.reminderTime != null
                ? TimeUtils.formatForStorage(fs.reminderTime!)
                : null,
            categoryId: fs.selectedCategory?.id,
            frequency: fs.selectedFrequency ?? HabitFrequency.daily,
            customDays: fs.customDays,
            endDate: fs.endDate,
          );

          await notifier.updateHabit(updatedHabit);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Habit updated successfully!')),
            );
            Navigator.pop(context);
          }
        }
      } finally {
        if (context.mounted) {
          ref.read(habitFormProvider.notifier).setSaving(false);
        }
      }
    }

    return ThemeScaffold(
      showThemeButton: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 24,
                    color: colors.textPrimary,
                  ),
                ),
                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.heading(
                      context,
                    ).copyWith(fontSize: 16.sp),
                  ),
                ),
                const ThemeSwitchButton(),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  AppTextField(
                    initialValue: initialHabit?.name ?? '',
                    hintText: 'Habit Name',
                    borderStyle: AppTextFieldBorderStyle.underline,
                    style: AppTextStyles.body(context),
                    onChanged: (val) =>
                        ref.read(habitFormProvider.notifier).updateName(val),
                  ),

                  const SizedBox(height: 32),

                  // Section header: General information + REQUIRED badge
                  Row(
                    children: [
                      Text(
                        'General information',
                        style: AppTextStyles.heading(
                          context,
                        ).copyWith(fontSize: 14.sp, color: colors.textPrimary),
                      ),
                      SizedBox(width: 8.sp),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.sp,
                          vertical: 2.sp,
                        ),
                        decoration: BoxDecoration(
                          color: colors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'REQUIRED',
                          style: AppTextStyles.caption(context).copyWith(
                            color: colors.error,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.sp),

                  // Grouped card: Category + Start date
                  Container(
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        // Category row
                        Padding(
                          padding: EdgeInsets.all(12.sp),
                          child: CategorySelector(
                            selectedCategory: formState.selectedCategory,
                            onCategorySelected: (category) {
                              ref
                                  .read(habitFormProvider.notifier)
                                  .setCategory(category);
                            },
                            onCategoryRemoved: () {
                              ref
                                  .read(habitFormProvider.notifier)
                                  .clearCategory();
                            },
                          ),
                        ),

                        Divider(
                          height: 1,
                          indent: 16.sp,
                          endIndent: 16.sp,
                          color: colors.textSecondary.withValues(alpha: 0.15),
                        ),

                        // Start date row
                        FormRowSelector(
                          icon: Icons.calendar_today,
                          iconColor: colors.dateBlue,
                          label: 'Start date',
                          value: dateText,
                          hasValue: formState.selectedDate != null,
                          onTap: selectDate,
                        ),

                        Divider(
                          height: 1,
                          indent: 16.sp,
                          endIndent: 16.sp,
                          color: colors.textSecondary.withValues(alpha: 0.15),
                        ),

                        // End date row
                        FormRowSelector(
                          icon: Icons.event_busy,
                          iconColor: colors.dateOrange,
                          label: 'End date',
                          value: formState.endDate != null
                              ? _dateFormat.format(formState.endDate!)
                              : 'No end date',
                          hasValue: formState.endDate != null,
                          onTap: selectEndDate,
                          trailing: formState.endDate != null
                              ? GestureDetector(
                                  onTap: () {
                                    ref
                                        .read(habitFormProvider.notifier)
                                        .setEndDate(null);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(4.sp),
                                    child: Icon(
                                      Icons.close,
                                      color: colors.textSecondary,
                                      size: 18.sp,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  const FrequencySelector(),

                  const SizedBox(height: 32),

                  ReminderSelector(
                    hasReminder: formState.hasReminder,
                    reminderTime: formState.reminderTime,
                    onReminderToggled: (enabled) {
                      ref.read(habitFormProvider.notifier).setReminder(enabled);
                    },
                    onTimeSelected: (time) {
                      ref
                          .read(habitFormProvider.notifier)
                          .setReminderTime(time);
                    },
                    onReminderRemoved: () {
                      ref.read(habitFormProvider.notifier).clearReminder();
                    },
                  ),

                  const SizedBox(height: 48),

                  AppButton(
                    text: buttonText,
                    isLoading: isLoading,
                    onPressed: saveHabit,
                    variant: AppButtonVariant.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
