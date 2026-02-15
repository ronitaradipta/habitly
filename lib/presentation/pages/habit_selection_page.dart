import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/presentation/widgets/habit/habit_card.dart';
import 'package:habitly/presentation/widgets/shared/buttons/theme_switch_button.dart';
import 'package:habitly/presentation/widgets/shared/onboarding/onboarding_progress_bar.dart';
import 'package:habitly/presentation/widgets/shared/onboarding/onboarding_button_row.dart';
import 'package:habitly/presentation/providers/habit_provider.dart';
import 'package:habitly/presentation/providers/habit_selection_provider.dart';
import 'package:habitly/core/constants/preset_habits.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:sizer/sizer.dart';

class HabitSelectionPage extends ConsumerWidget {
  const HabitSelectionPage({super.key});

  Future<void> _proceed(BuildContext context, WidgetRef ref) async {
    final selectionState = ref.read(habitSelectionProvider);
    final notifier = ref.read(currentUserHabitsNotifierProvider);
    if (notifier == null) return;

    final selectedHabitData = selectionState.selectedHabits.map((habitId) {
      final preset = presetHabits.firstWhere((p) => p.id == habitId);
      return {
        'name': preset.name,
        'iconCodePoint': preset.iconCodePoint,
      };
    }).toList();

    await notifier.setupOnboardingHabits(selectedHabitData);

    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/reminder-time');
    }
  }

  void _skip(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/reminder-time');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final selectionState = ref.watch(habitSelectionProvider);
    final selectionNotifier = ref.read(habitSelectionProvider.notifier);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress indicator
                const OnboardingProgressBar(value: 0.5),

                // Heading
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "What habit do you want to do?",
                        style: AppTextStyles.heading(
                          context,
                          FontEngine.google,
                        ).copyWith(fontSize: 18.sp),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Select One or More",
                        style: AppTextStyles.caption(
                          context,
                          FontEngine.google,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Habit grid
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.1,
                      ),
                      itemCount: presetHabits.length,
                      itemBuilder: (context, index) {
                        final habit = presetHabits[index];
                        final isSelected = selectionState.isSelected(habit.id);
                        return HabitCard(
                          id: habit.id,
                          name: habit.name,
                          iconCodePoint: habit.iconCodePoint,
                          isSelected: isSelected,
                          colors: colors,
                          onTap: () => selectionNotifier.toggleHabit(habit.id),
                        );
                      },
                    ),
                  ),
                ),

                // Bottom buttons
                OnboardingButtonRow(
                  onSkip: () => _skip(context),
                  onProceed: selectionState.hasSelection
                      ? () => _proceed(context, ref)
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
