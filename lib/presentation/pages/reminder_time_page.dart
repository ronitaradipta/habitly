import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/constants/routes.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/presentation/providers/auth_provider.dart';
import 'package:habitly/presentation/providers/habit_provider.dart';
import 'package:habitly/presentation/providers/reminder_time_provider.dart';
import 'package:habitly/presentation/widgets/shared/theme_scaffold.dart';
import 'package:habitly/presentation/widgets/shared/dialogs/app_time_picker.dart';
import 'package:habitly/presentation/widgets/shared/onboarding/onboarding_button_row.dart';
import 'package:habitly/presentation/widgets/shared/onboarding/onboarding_progress_bar.dart';
import 'package:sizer/sizer.dart';

class _TimePreset {
  final String id;
  final String displayTime;
  final String label;
  final IconData icon;
  const _TimePreset({
    required this.id,
    required this.displayTime,
    required this.label,
    required this.icon,
  });
}

class ReminderTimePage extends ConsumerStatefulWidget {
  const ReminderTimePage({super.key});

  static const _timeOptions = [
    _TimePreset(
      id: 'morning',
      displayTime: '7:00 AM',
      label: 'Morning',
      icon: Icons.wb_sunny_outlined,
    ),
    _TimePreset(
      id: 'afternoon',
      displayTime: '1:00 PM',
      label: 'Afternoon',
      icon: Icons.wb_cloudy_outlined,
    ),
    _TimePreset(
      id: 'evening',
      displayTime: '7:00 PM',
      label: 'Evening',
      icon: Icons.nightlight_outlined,
    ),
  ];

  @override
  ConsumerState<ReminderTimePage> createState() => _ReminderTimePageState();
}

class _ReminderTimePageState extends ConsumerState<ReminderTimePage> {
  bool _isLoading = false;

  Future<void> _showTimePicker() async {
    final reminderState = ref.read(reminderTimeProvider);

    final picked = await showAppTimePicker(
      context,
      initialTime: reminderState.customTime,
    );

    if (picked != null) {
      ref.read(reminderTimeProvider.notifier).setCustomTime(picked);
    }
  }

  Future<void> _proceed() async {
    setState(() => _isLoading = true);

    try {
      final reminderState = ref.read(reminderTimeProvider);
      final timeValue = reminderState.timeValue;

      if (timeValue != null) {
        final notifier = ref.read(habitProvider.notifier);
        await notifier.updateHabitsReminder(timeValue);
      }

      await ref.read(authProvider.notifier).markOnboardingComplete();
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _skip() async {
    setState(() => _isLoading = true);

    try {
      await ref.read(authProvider.notifier).markOnboardingComplete();
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final reminderState = ref.watch(reminderTimeProvider);
    final reminderNotifier = ref.read(reminderTimeProvider.notifier);
    final habitCount = ref.watch(habitProvider).asData?.value.length ?? 0;

    return ThemeScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const OnboardingProgressBar(value: 1.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "When should we remind you?",
                  style: AppTextStyles.heading(
                    context,
                  ).copyWith(fontSize: 18.sp),
                ),
                const SizedBox(height: 4),
                Text(
                  "Pick a time that works for your routine",
                  style: AppTextStyles.caption(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: ReminderTimePage._timeOptions.map((preset) {
                final isSelected =
                    reminderState.customTime == null &&
                    reminderState.selectedTime == preset.id;

                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: preset.id != 'evening' ? 12 : 0,
                    ),
                    child: _TimeChip(
                      preset: preset,
                      isSelected: isSelected,
                      onTap: () => reminderNotifier.selectTime(preset.id),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GestureDetector(
              onTap: _showTimePicker,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.sp,
                  vertical: 14.sp,
                ),
                decoration: BoxDecoration(
                  color: reminderState.customTime != null
                      ? colors.primary.withValues(alpha: 0.1)
                      : colors.surface,
                  border: Border.all(
                    color: reminderState.customTime != null
                        ? colors.primary
                        : colors.border,
                    width: reminderState.customTime != null ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: reminderState.customTime != null
                          ? colors.primary
                          : colors.textSecondary,
                      size: 20.sp,
                    ),
                    SizedBox(width: 12.sp),
                    Expanded(
                      child: Text(
                        reminderState.customTime != null
                            ? reminderState.displayTime!
                            : 'Pick custom time',
                        style: AppTextStyles.body(context).copyWith(
                          color: reminderState.customTime != null
                              ? colors.primary
                              : colors.textSecondary,
                          fontWeight: reminderState.customTime != null
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    if (reminderState.customTime != null)
                      GestureDetector(
                        onTap: () => reminderNotifier.clearSelection(),
                        child: Icon(
                          Icons.close,
                          color: colors.primary,
                          size: 18.sp,
                        ),
                      )
                    else
                      Icon(
                        Icons.chevron_right,
                        color: colors.textSecondary,
                        size: 20.sp,
                      ),
                  ],
                ),
              ),
            ),
          ),
          const Spacer(),
          if (reminderState.hasSelection && habitCount > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                '$habitCount habit${habitCount == 1 ? '' : 's'} will be created with daily reminders at ${reminderState.displayTime}',
                style: AppTextStyles.caption(context),
                textAlign: TextAlign.center,
              ),
            ),
          if (reminderState.hasSelection && habitCount > 0)
            const SizedBox(height: 8),
          OnboardingButtonRow(
            onSkip: _skip,
            proceedText: "Let's Go!",
            onProceed: reminderState.hasSelection ? _proceed : null,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  final _TimePreset preset;
  final bool isSelected;
  final VoidCallback onTap;

  const _TimeChip({
    required this.preset,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.sp),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primary.withValues(alpha: 0.1)
              : colors.surface,
          border: Border.all(
            color: isSelected ? colors.primary : colors.border,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              preset.icon,
              color: isSelected ? colors.primary : colors.textSecondary,
              size: 22.sp,
            ),
            SizedBox(height: 6.sp),
            Text(
              preset.displayTime,
              style: AppTextStyles.bodyBold(context).copyWith(
                fontSize: 12.sp,
                color: isSelected ? colors.primary : colors.textPrimary,
              ),
            ),
            SizedBox(height: 2.sp),
            Text(
              preset.label,
              style: AppTextStyles.captionSmall(context).copyWith(
                color: isSelected ? colors.primary : colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
