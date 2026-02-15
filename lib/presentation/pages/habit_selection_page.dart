import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/presentation/widgets/habit/habit_card.dart';
import 'package:habitly/presentation/widgets/shared/buttons/theme_switch_button.dart';
import 'package:habitly/presentation/widgets/shared/onboarding/onboarding_progress_bar.dart';
import 'package:habitly/presentation/widgets/shared/onboarding/onboarding_button_row.dart';
import 'package:habitly/presentation/providers/habit_provider.dart';
import 'package:habitly/presentation/providers/habit_selection_provider.dart';
import 'package:habitly/presentation/providers/auth_provider.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:sizer/sizer.dart';

final List<Map<String, dynamic>> _availableHabits = [
  {
    'id': 'take_picture',
    'name': 'Take Picture',
    'iconCodePoint': Icons.camera_alt_outlined.codePoint,
  },
  {
    'id': 'workout',
    'name': 'Workout',
    'iconCodePoint': Icons.fitness_center.codePoint,
  },
  {
    'id': 'journaling',
    'name': 'Journaling',
    'iconCodePoint': Icons.edit_outlined.codePoint,
  },
  {
    'id': 'planning',
    'name': 'Planning',
    'iconCodePoint': Icons.calendar_month_outlined.codePoint,
  },
  {
    'id': 'game_tracking',
    'name': 'Game Tracking',
    'iconCodePoint': Icons.sports_esports_outlined.codePoint,
  },
  {
    'id': 'reading',
    'name': 'Reading',
    'iconCodePoint': Icons.menu_book_outlined.codePoint,
  },
  {
    'id': 'music_time',
    'name': 'Music time',
    'iconCodePoint': Icons.music_note_outlined.codePoint,
  },
  {
    'id': 'sleep_early',
    'name': 'Sleep Early',
    'iconCodePoint': Icons.bed_outlined.codePoint,
  },
];

class HabitSelectionPage extends ConsumerWidget {
  const HabitSelectionPage({super.key});

  Future<void> _proceed(BuildContext context, WidgetRef ref) async {
    final selectionState = ref.read(habitSelectionProvider);

    // Load existing habits and clear them to start fresh with current selection
    final email = ref.read(currentUserEmailProvider);
    final existingHabits = email != null
        ? (ref.read(habitProvider(email)).value ?? [])
        : <Habit>[];
    final notifier = ref.read(currentUserHabitsNotifierProvider);
    if (notifier == null) return;

    for (var habit in existingHabits) {
      await notifier.deleteHabit(habit.id);
    }

    for (var habitId in selectionState.selectedHabits) {
      final habitData = _availableHabits.firstWhere(
        (element) => element['id'] == habitId,
      );
      await notifier.addHabit(
        name: habitData['name'],
        date: DateTime.now(),
        period: ReminderPeriod.morning,
      );
    }

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
                        "What habbit you want to do?",
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
                      itemCount: _availableHabits.length,
                      itemBuilder: (context, index) {
                        final habit = _availableHabits[index];
                        final isSelected = selectionState.isSelected(
                          habit['id'],
                        );
                        return HabitCard(
                          id: habit['id'],
                          name: habit['name'],
                          iconCodePoint: habit['iconCodePoint'],
                          isSelected: isSelected,
                          colors: colors,
                          onTap: () =>
                              selectionNotifier.toggleHabit(habit['id']),
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
