import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/presentation/widgets/shared/form_row_selector.dart';
import 'package:habitly/presentation/widgets/shared/buttons/app_button.dart';
import 'package:habitly/presentation/widgets/shared/inputs/app_text_field.dart';
import 'package:habitly/presentation/widgets/shared/navigation/custom_app_bar.dart';
import 'package:habitly/presentation/widgets/habit/frequency_selector.dart';
import 'package:habitly/presentation/widgets/habit/reminder_selector.dart';
import 'package:habitly/presentation/widgets/habit/ai_habit_generator_tab.dart';
import 'package:habitly/presentation/widgets/habit/category_selector.dart';
import 'package:habitly/presentation/widgets/shared/required_badge.dart';
import 'package:habitly/presentation/providers/habit_form_provider.dart';
import 'package:habitly/presentation/utils/snackbar_utils.dart';
import 'package:habitly/presentation/widgets/shared/theme_scaffold.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:sizer/sizer.dart';

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
    if (mode == FormMode.create) {
      return ProviderScope(
        overrides: [
          habitFormProvider.overrideWith(() => HabitFormNotifier(initialHabit)),
        ],
        child: _TabbedHabitForm(initialHabit: initialHabit, onDelete: onDelete),
      );
    }
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

class _TabbedHabitForm extends ConsumerStatefulWidget {
  final Habit? initialHabit;
  final VoidCallback? onDelete;

  const _TabbedHabitForm({this.initialHabit, this.onDelete});

  @override
  ConsumerState<_TabbedHabitForm> createState() => _TabbedHabitFormState();
}

class _TabbedHabitFormState extends ConsumerState<_TabbedHabitForm>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return ThemeScaffold(
      showThemeButton: false,
      body: Column(
        children: [
          const CustomAppBar(title: 'Add New Habit', showBackButton: true),

          // Tab Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: colors.surface,
              unselectedLabelColor: colors.textSecondary,
              labelStyle: AppTextStyles.bodySmall(
                context,
              ).copyWith(fontWeight: FontWeight.w600),
              unselectedLabelStyle: AppTextStyles.bodySmall(context),
              tabs: const [
                Tab(text: 'Manual'),
                Tab(text: 'AI Generate'),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _HabitFormFields(
                    mode: FormMode.create,
                    initialHabit: widget.initialHabit,
                  ),
                ),
                const AiHabitGeneratorTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HabitFormBody extends ConsumerWidget {
  final FormMode mode;
  final Habit? initialHabit;
  final VoidCallback? onDelete;

  const _HabitFormBody({required this.mode, this.initialHabit, this.onDelete});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = mode == FormMode.create ? 'Add New Habit' : 'Edit Habit';

    return ThemeScaffold(
      showThemeButton: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(title: title, showBackButton: true),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _HabitFormFields(mode: mode, initialHabit: initialHabit),
            ),
          ),
        ],
      ),
    );
  }
}

class _HabitFormFields extends ConsumerWidget {
  final FormMode mode;
  final Habit? initialHabit;

  static final _dateFormat = DateFormat('MM/dd/yyyy');

  const _HabitFormFields({required this.mode, this.initialHabit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final formState = ref.watch(habitFormProvider);
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

    ref.listen<HabitFormState>(habitFormProvider, (previous, next) {
      if (next.saveResult != previous?.saveResult) {
        switch (next.saveResult) {
          case SaveResult.created:
            AppSnackBar.showSuccess(context, 'Habit added successfully!');
            Navigator.pop(context);
          case SaveResult.updated:
            AppSnackBar.showSuccess(context, 'Habit updated successfully!');
            Navigator.pop(context);
          case SaveResult.validationError:
            AppSnackBar.showError(
              context,
              next.validationError ?? 'Validation failed',
            );
          case SaveResult.saveError:
            AppSnackBar.showError(
              context,
              next.validationError ?? 'Failed to save habit',
            );
          case SaveResult.none:
            break;
        }
      }
    });

    return Column(
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

        Row(
          children: [
            Text(
              'General information',
              style: AppTextStyles.heading(
                context,
              ).copyWith(fontSize: 14.sp, color: colors.textPrimary),
            ),
            SizedBox(width: 8.sp),
            const RequiredBadge(),
          ],
        ),
        SizedBox(height: 12.sp),

        Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(12.sp),
                child: CategorySelector(
                  selectedCategory: formState.selectedCategory,
                  onCategorySelected: (category) {
                    ref.read(habitFormProvider.notifier).setCategory(category);
                  },
                  onCategoryRemoved: () {
                    ref.read(habitFormProvider.notifier).clearCategory();
                  },
                ),
              ),
              Divider(
                height: 1,
                indent: 16.sp,
                endIndent: 16.sp,
                color: colors.textSecondary.withValues(alpha: 0.15),
              ),
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
                          ref.read(habitFormProvider.notifier).setEndDate(null);
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
            ref.read(habitFormProvider.notifier).setReminderTime(time);
          },
          onReminderRemoved: () {
            ref.read(habitFormProvider.notifier).clearReminder();
          },
        ),

        const SizedBox(height: 48),

        AppButton(
          text: buttonText,
          isLoading: isLoading,
          onPressed: () => ref
              .read(habitFormProvider.notifier)
              .saveHabit(mode, initialHabit),
          variant: AppButtonVariant.primary,
        ),

        const SizedBox(height: 32),
      ],
    );
  }
}
