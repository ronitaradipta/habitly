import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/presentation/widgets/shared/buttons/theme_switch_button.dart';
import 'package:habitly/presentation/widgets/shared/onboarding/onboarding_progress_bar.dart';
import 'package:habitly/presentation/widgets/shared/onboarding/onboarding_button_row.dart';
import 'package:habitly/presentation/widgets/habit/time_option_card.dart';
import 'package:habitly/presentation/providers/auth_provider.dart';
import 'package:habitly/presentation/providers/habit_provider.dart';
import 'package:habitly/presentation/providers/reminder_time_provider.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/core/constants/routes.dart';
import 'package:sizer/sizer.dart';

class ReminderTimePage extends ConsumerWidget {
  const ReminderTimePage({super.key});

  // Use centralized ReminderPeriod values
  static final List<ReminderPeriod> _timeOptions = ReminderPeriod.values;

  Future<void> _proceed(
    BuildContext context,
    WidgetRef ref,
    String? selectedTime,
  ) async {
    if (selectedTime != null) {
      final period = ReminderPeriodExtension.fromId(selectedTime);
      if (period == null) return;

      final notifier = ref.read(habitProvider.notifier);

      await notifier.updateHabitsReminder(period);
    }
    // Mark onboarding as complete
    await ref.read(authProvider.notifier).markOnboardingComplete();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.onboardingComplete);
    }
  }

  Future<void> _skip(BuildContext context, WidgetRef ref) async {
    // Mark onboarding as complete even when skipping
    await ref.read(authProvider.notifier).markOnboardingComplete();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.onboardingComplete);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final reminderState = ref.watch(reminderTimeProvider);
    final reminderNotifier = ref.read(reminderTimeProvider.notifier);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress indicator
                const OnboardingProgressBar(value: 1.0),

                // Heading
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    "When you wanna us remind you ?",
                    style: AppTextStyles.heading(
                      context,
                    ).copyWith(fontSize: 18.sp),
                  ),
                ),
                const SizedBox(height: 24),

                // Time options grid
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: _timeOptions.length,
                      itemBuilder: (context, index) {
                        final period = _timeOptions[index];
                        final isSelected =
                            reminderState.selectedTime == period.id;
                        return TimeOptionCard(
                          id: period.id,
                          time: period.time,
                          label: period.label,
                          isSelected: isSelected,
                          onTap: () => reminderNotifier.selectTime(period.id),
                        );
                      },
                    ),
                  ),
                ),

                // Bottom buttons
                OnboardingButtonRow(
                  onSkip: () => _skip(context, ref),
                  onProceed: reminderState.hasSelection
                      ? () => _proceed(context, ref, reminderState.selectedTime)
                      : null,
                ),
              ],
            ),
            const Positioned(top: 16, right: 16, child: ThemeSwitchButton()),
          ],
        ),
      ),
    );
  }
}
