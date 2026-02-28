import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:habitly/core/utils/time_utils.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/presentation/widgets/shared/form_row_selector.dart';
import 'package:habitly/domain/validators/habit_validators.dart';
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

class HabitForm extends ConsumerStatefulWidget {
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
  ConsumerState<HabitForm> createState() => _HabitFormState();
}

class _HabitFormState extends ConsumerState<HabitForm> {
  final TextEditingController _nameController = TextEditingController();
  final _dateFormat = DateFormat('MM/dd/yyyy');

  @override
  void initState() {
    super.initState();
    if (widget.mode == FormMode.edit && widget.initialHabit != null) {
      _nameController.text = widget.initialHabit!.name;
      Future.microtask(() {
        ref
            .read(habitFormProvider.notifier)
            .initFromHabit(widget.initialHabit!);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final formState = ref.read(habitFormProvider);
    final picked = await showDatePicker(
      context: context,
      initialDate: formState.selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      ref.read(habitFormProvider.notifier).selectDate(picked);
    }
  }

  Future<void> _selectEndDate() async {
    final formState = ref.read(habitFormProvider);
    final startDate = formState.selectedDate ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: formState.endDate ?? startDate,
      firstDate: startDate,
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      ref.read(habitFormProvider.notifier).setEndDate(picked);
    }
  }

  void _showValidationError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _saveHabit() async {
    final formState = ref.read(habitFormProvider);

    final nameResult = HabitValidators.validateHabitName(_nameController.text);
    if (!nameResult.isValid) {
      _showValidationError(nameResult.errorMessage ?? 'Validation failed');
      return;
    }

    final dateResult = HabitValidators.validateHabitDate(
      formState.selectedDate,
    );
    if (!dateResult.isValid) {
      _showValidationError(dateResult.errorMessage ?? 'Validation failed');
      return;
    }

    final endDateResult = HabitValidators.validateEndDate(
      formState.endDate,
      formState.selectedDate,
    );
    if (!endDateResult.isValid) {
      _showValidationError(endDateResult.errorMessage ?? 'Validation failed');
      return;
    }

    ref.read(habitFormProvider.notifier).setSaving(true);

    try {
      final notifier = ref.read(habitProvider.notifier);

      if (widget.mode == FormMode.create) {
        final iconName =
            formState.selectedCategory?.iconName ?? 'fitness_center';

        await notifier.addHabit(
          name: _nameController.text,
          iconName: iconName,
          date: formState.selectedDate!,
          hasReminder: formState.hasReminder,
          reminderTime: formState.reminderTime,
          categoryId: formState.selectedCategory?.id,
          frequency: formState.selectedFrequency ?? HabitFrequency.daily,
          customDays: formState.customDays,
          endDate: formState.endDate,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Habit added successfully!')),
          );
          Navigator.pop(context);
        }
      } else {
        if (widget.initialHabit == null) return;

        final updatedHabit = widget.initialHabit!.copyWith(
          name: _nameController.text,
          targetDate: formState.selectedDate,
          hasReminder: formState.hasReminder,
          reminderTime: formState.reminderTime != null
              ? TimeUtils.formatForStorage(formState.reminderTime!)
              : null,
          categoryId: formState.selectedCategory?.id,
          frequency: formState.selectedFrequency ?? HabitFrequency.daily,
          customDays: formState.customDays,
          endDate: formState.endDate,
        );

        await notifier.updateHabit(updatedHabit);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Habit updated successfully!')),
          );
          Navigator.pop(context);
        }
      }
    } finally {
      if (mounted) {
        ref.read(habitFormProvider.notifier).setSaving(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final formState = ref.watch(habitFormProvider);
    final title = widget.mode == FormMode.create
        ? 'Add New Habit'
        : 'Edit Habit';
    final buttonText = widget.mode == FormMode.create
        ? 'Save Habit'
        : 'Update Habit';

    final isLoading = formState.isSaving;

    final dateText = formState.selectedDate != null
        ? _dateFormat.format(formState.selectedDate!)
        : 'Select date';

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
                      controller: _nameController,
                      hintText: 'Habit Name',
                      borderStyle: AppTextFieldBorderStyle.underline,
                      style: AppTextStyles.body(context),
                    ),

                    const SizedBox(height: 32),

                    // Section header: General information + REQUIRED badge
                    Row(
                      children: [
                        Text(
                          'General information',
                          style: AppTextStyles.heading(context).copyWith(
                            fontSize: 14.sp,
                            color: colors.textPrimary,
                          ),
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
                            onTap: _selectDate,
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
                            onTap: _selectEndDate,
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
                        ref
                            .read(habitFormProvider.notifier)
                            .setReminder(enabled);
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
                      onPressed: _saveHabit,
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
