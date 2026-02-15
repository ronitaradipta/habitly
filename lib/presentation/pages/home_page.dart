import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/presentation/widgets/shared/navigation/bottom_nav_bar.dart';
import 'package:habitly/presentation/widgets/habit/home_habit_tile.dart';
import 'package:habitly/presentation/widgets/shared/buttons/theme_switch_button.dart';
import 'package:habitly/presentation/widgets/habit/week_day_selector.dart';
import 'package:habitly/presentation/providers/auth_provider.dart';
import 'package:habitly/presentation/providers/habit_provider.dart';
import 'package:habitly/presentation/providers/filtered_habits_provider.dart';
import 'package:habitly/presentation/providers/selected_date_provider.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:sizer/sizer.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final now = DateTime.now();
    final dateFormat = DateFormat('MMMM d');
    final filteredHabitsAsync = ref.watch(filteredHabitsProvider);
    final selectedDate = ref.watch(selectedDateProvider);

    Future<void> onBottomNavTap(BottomNavItem item) async {
      switch (item) {
        case BottomNavItem.home:
          // Already on home
          break;
        case BottomNavItem.add:
          await Navigator.pushNamed(context, '/add-habit');
          break;
        case BottomNavItem.profile:
          // Navigate to profile, for now just placeholder
          break;
      }
    }

    Future<void> onAccountTap() async {
      await ref.read(authProvider.notifier).logout();
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }

    Future<void> editHabit(Habit habit) async {
      await Navigator.pushNamed(context, '/edit-habit', arguments: habit.id);
    }

    Future<void> deleteHabit(Habit habit) async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: colors.surface,
          title: Text(
            'Delete Habit',
            style: TextStyle(color: colors.textPrimary),
          ),
          content: Text(
            'Are you sure you want to delete "${habit.name}"?',
            style: TextStyle(color: colors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(
                'Cancel',
                style: TextStyle(color: colors.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        final notifier = ref.read(currentUserHabitsNotifierProvider);
        if (notifier != null) {
          await notifier.deleteHabit(habit.id);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Habit "${habit.name}" deleted')),
            );
          }
        }
      }
    }

    Future<void> toggleHabitCompletion(Habit habit) async {
      final notifier = ref.read(currentUserHabitsNotifierProvider);
      if (notifier != null) {
        await notifier.toggleCompletion(habit.id);
      }
    }

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Date display
                  Row(
                    children: [
                      Text(
                        'Today,',
                        style: AppTextStyles.heading(
                          context,
                          FontEngine.google,
                        ).copyWith(fontSize: 18.sp),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        dateFormat.format(now),
                        style: AppTextStyles.heading(
                          context,
                          FontEngine.google,
                        ).copyWith(fontSize: 18.sp),
                      ),
                    ],
                  ),
                  // Account icon
                  Row(
                    children: [
                      const ThemeSwitchButton(),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: onAccountTap,
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

            // Week Day Selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: WeekDaySelector(
                selectedDate: selectedDate,
                onDateSelected: (date) {
                  ref.read(selectedDateProvider.notifier).selectDate(date);
                },
              ),
            ),

            const SizedBox(height: 24),

            // My Habit Section Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'My Habbit',
                style: AppTextStyles.heading(
                  context,
                  FontEngine.google,
                ).copyWith(fontSize: 16.sp),
              ),
            ),

            const SizedBox(height: 8),

            // Habit List
            Expanded(
              child: filteredHabitsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Center(
                  child: Text(
                    'Error: $e',
                    style: AppTextStyles.caption(context, FontEngine.google),
                  ),
                ),
                data: (habits) {
                  if (habits.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/empty_habits.svg',
                            width: 120,
                            height: 120,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No habits for this day',
                            style: AppTextStyles.caption(
                              context,
                              FontEngine.google,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: habits.length,
                    itemBuilder: (context, index) {
                      final habit = habits[index];
                      return HomeHabitTile(
                        habit: habit,
                        onTap: () => toggleHabitCompletion(habit),
                        onEdit: () => editHabit(habit),
                        onDelete: () => deleteHabit(habit),
                      );
                    },
                  );
                },
              ),
            ),

            // Bottom Navigation Bar
            BottomNavBar(
              currentItem: BottomNavItem.home,
              onItemTapped: onBottomNavTap,
            ),
          ],
        ),
      ),
    );
  }
}
