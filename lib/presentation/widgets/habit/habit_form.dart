import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/presentation/widgets/shared/buttons/app_button.dart';
import 'package:habitly/presentation/widgets/shared/buttons/theme_switch_button.dart';
import 'package:habitly/presentation/widgets/shared/inputs/app_text_field.dart';
import 'package:habitly/presentation/widgets/habit/time_period_button.dart';
import 'package:habitly/presentation/providers/habit_form_provider.dart';
import 'package:habitly/presentation/providers/habit_provider.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/core/utils/validators.dart';
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

  @override
  void initState() {
    super.initState();
    // Initialize with existing habit data if in edit mode
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

  void _onAccountTap() {
    Navigator.pushReplacementNamed(context, '/login');
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

  Future<void> _saveHabit() async {
    final formState = ref.read(habitFormProvider);

    // Use centralized validators from validators.dart
    final nameResult = Validators.validateHabitName(_nameController.text);
    if (!nameResult.isValid) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(nameResult.errorMessage ?? 'Validation failed'),
          ),
        );
      }
      return;
    }

    final dateResult = Validators.validateHabitDate(formState.selectedDate);
    if (!dateResult.isValid) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(dateResult.errorMessage ?? 'Validation failed'),
          ),
        );
      }
      return;
    }

    final periodResult = Validators.validateHabitPeriod(
      formState.selectedPeriod,
    );
    if (!periodResult.isValid) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(periodResult.errorMessage ?? 'Validation failed'),
          ),
        );
      }
      return;
    }

    // Call appropriate provider method based on mode
    if (widget.mode == FormMode.create) {
      final notifier = ref.read(currentUserHabitsNotifierProvider);
      if (notifier == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please log in to add habits')),
          );
        }
        return;
      }
      await notifier.addHabit(
        name: _nameController.text,
        iconCodePoint: Icons.fitness_center.codePoint,
        date: formState.selectedDate!,
        period: formState.selectedPeriod!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Habit added successfully!')),
        );
        Navigator.pop(context);
      }
    } else {
      // Edit mode
      if (widget.initialHabit == null) return;

      final updatedHabit = widget.initialHabit!.copyWith(
        name: _nameController.text,
        targetDate: formState.selectedDate,
        reminderPeriod: formState.selectedPeriod,
        completionTime: formState.selectedPeriod?.time,
      );

      final notifier = ref.read(currentUserHabitsNotifierProvider);
      if (notifier == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please log in to update habits')),
          );
        }
        return;
      }
      await notifier.updateHabit(updatedHabit);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Habit updated successfully!')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final dateFormat = DateFormat('MM/dd/yyyy');
    final formState = ref.watch(habitFormProvider);
    final title = widget.mode == FormMode.create
        ? 'Add New Habit'
        : 'Edit Habit';
    final buttonText = widget.mode == FormMode.create
        ? 'Save Habit'
        : 'Update Habit';

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 24,
                      color: colors.textPrimary,
                    ),
                  ),

                  // Title
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.heading(
                        context,
                        FontEngine.google,
                      ).copyWith(fontSize: 16.sp),
                    ),
                  ),

                  // Account icon and theme switch
                  Row(
                    children: [
                      const ThemeSwitchButton(),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _onAccountTap,
                        child: Icon(
                          Icons.person_outline,
                          size: 28,
                          color: colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
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

                    // Habit Name Field
                    AppTextField(
                      controller: _nameController,
                      hintText: 'Habit Name',
                      borderStyle: AppTextFieldBorderStyle.underline,
                      style: AppTextStyles.body(context, FontEngine.google),
                    ),

                    const SizedBox(height: 32),

                    // Date Picker Field
                    AppTextField(
                      controller: TextEditingController(
                        text: formState.selectedDate != null
                            ? dateFormat.format(formState.selectedDate!)
                            : '',
                      ),
                      readOnly: true,
                      onTap: _selectDate,
                      hintText: 'Select Date',
                      borderStyle: AppTextFieldBorderStyle.underline,
                      style: AppTextStyles.body(context, FontEngine.google),
                      suffixIcon: Icon(
                        Icons.calendar_today_outlined,
                        color: colors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Reminder Time Section
                    Text(
                      'When we should remind you ?',
                      style: AppTextStyles.heading(
                        context,
                        FontEngine.google,
                      ).copyWith(fontSize: 14.sp),
                    ),

                    const SizedBox(height: 24),

                    // Time Period Buttons
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: ReminderPeriod.values.map((period) {
                        return TimePeriodButton(
                          label: period.label,
                          isSelected: formState.selectedPeriod == period,
                          onTap: () {
                            ref
                                .read(habitFormProvider.notifier)
                                .selectPeriod(period);
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 48),

                    // Save Button
                    AppButton(
                      text: buttonText,
                      onPressed: _saveHabit,
                      variant: AppButtonVariant.primary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
