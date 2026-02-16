import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/validators/habit_validators.dart';
import 'package:habitly/presentation/widgets/shared/buttons/app_button.dart';
import 'package:habitly/presentation/widgets/shared/buttons/theme_switch_button.dart';
import 'package:habitly/presentation/widgets/shared/inputs/app_text_field.dart';
import 'package:habitly/presentation/widgets/habit/time_period_button.dart';
import 'package:habitly/presentation/providers/habit_form_provider.dart';
import 'package:habitly/presentation/providers/habit_provider.dart';
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
  final TextEditingController _dateController = TextEditingController();
  final _dateFormat = DateFormat('MM/dd/yyyy');

  @override
  void initState() {
    super.initState();
    if (widget.mode == FormMode.edit && widget.initialHabit != null) {
      _nameController.text = widget.initialHabit!.name;
      if (widget.initialHabit!.targetDate != null) {
        _dateController.text = _dateFormat.format(
          widget.initialHabit!.targetDate!,
        );
      }
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
    _dateController.dispose();
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
      _dateController.text = _dateFormat.format(picked);
    }
  }

  Future<void> _saveHabit() async {
    final formState = ref.read(habitFormProvider);

    final nameResult = HabitValidators.validateHabitName(_nameController.text);
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

    final dateResult = HabitValidators.validateHabitDate(
      formState.selectedDate,
    );
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

    final periodResult = HabitValidators.validateHabitPeriod(
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

    final notifier = ref.read(habitProvider.notifier);

    if (widget.mode == FormMode.create) {
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
      if (widget.initialHabit == null) return;

      final updatedHabit = widget.initialHabit!.copyWith(
        name: _nameController.text,
        targetDate: formState.selectedDate,
        reminderPeriod: formState.selectedPeriod,
        completionTime: formState.selectedPeriod?.time,
      );

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
    final formState = ref.watch(habitFormProvider);
    final title = widget.mode == FormMode.create
        ? 'Add New Habit'
        : 'Edit Habit';
    final buttonText = widget.mode == FormMode.create
        ? 'Save Habit'
        : 'Update Habit';

    final isLoading = ref.watch(habitProvider).isLoading;

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

                    AppTextField(
                      controller: _dateController,
                      readOnly: true,
                      onTap: _selectDate,
                      hintText: 'Select Date',
                      borderStyle: AppTextFieldBorderStyle.underline,
                      style: AppTextStyles.body(context),
                      suffixIcon: Icon(
                        Icons.calendar_today_outlined,
                        color: colors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 32),

                    Text(
                      'When we should remind you ?',
                      style: AppTextStyles.heading(
                        context,
                      ).copyWith(fontSize: 14.sp),
                    ),

                    const SizedBox(height: 24),

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
      ),
    );
  }
}
