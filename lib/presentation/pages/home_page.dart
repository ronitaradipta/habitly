import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habitly/core/utils/date_utils.dart';
import 'package:habitly/domain/entities/user.dart';
import 'package:habitly/presentation/widgets/shared/navigation/bottom_nav_bar.dart';
import 'package:habitly/presentation/widgets/habit/home_habit_tile.dart';
import 'package:habitly/presentation/widgets/shared/buttons/theme_switch_button.dart';
import 'package:habitly/presentation/widgets/habit/week_day_selector.dart';
import 'package:habitly/presentation/widgets/habit/habit_progress_indicator.dart';
import 'package:habitly/presentation/widgets/habit/category_filter_bar.dart';
import 'package:habitly/presentation/widgets/habit/custom_calendar.dart';
import 'package:habitly/presentation/widgets/shared/navigation/sidebar_drawer.dart';
import 'package:habitly/presentation/widgets/shared/theme_scaffold.dart';
import 'package:habitly/presentation/providers/auth_provider.dart';
import 'package:habitly/presentation/providers/habit_provider.dart';
import 'package:habitly/presentation/providers/filtered_habits_provider.dart';
import 'package:habitly/presentation/providers/selected_date_provider.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/core/constants/routes.dart';
import 'package:sizer/sizer.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final filteredHabitsAsync = ref.watch(filteredHabitsProvider);
    final selectedDate = ref.watch(selectedDateProvider);

    ref.listen(authProvider, (previous, next) {
      if (next is AsyncData<User?> && next.value == null && context.mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AppRoutes.launch, (route) => false);
      }
    });

    ref.listen<String?>(habitErrorProvider, (previous, next) {
      if (next != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next), behavior: SnackBarBehavior.floating),
        );
        ref.read(habitErrorProvider.notifier).setError(null);
      }
    });

    return ThemeScaffold(
      showThemeButton: false,
      drawer: const SidebarDrawer(),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Hamburger menu button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Builder(
                        builder: (context) => IconButton(
                          icon: Icon(Icons.menu, color: colors.textPrimary),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                          tooltip: 'Menu',
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Date label
                      Text(
                        AppDateUtils.formatDateLabel(selectedDate),
                        style: AppTextStyles.headingMedium(context),
                      ),
                    ],
                  ),

                  // Calendar and theme toggle
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.calendar_today_outlined,
                          color: colors.textPrimary,
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (modalContext) => SizedBox(
                              height:
                                  MediaQuery.of(modalContext).size.height * 0.5,
                              child: CustomCalendar(
                                selectedDate: selectedDate,
                                onDateSelected: (date) {
                                  ref
                                      .read(selectedDateProvider.notifier)
                                      .selectDate(date);
                                  Navigator.pop(modalContext);
                                },
                              ),
                            ),
                          );
                        },
                        tooltip: 'Calendar',
                      ),
                      const SizedBox(width: 8),
                      const ThemeSwitchButton(),
                    ],
                  ),
                ],
              ),
            ),

            // Week Day Selector
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: WeekDaySelector(),
            ),

            const SizedBox(height: 24),

            // Progress Indicator
            HabitProgressIndicator(),

            const SizedBox(height: 24),

            // My Habit Section Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'My Habit',
                style: AppTextStyles.heading(context).copyWith(fontSize: 16.sp),
              ),
            ),

            const SizedBox(height: 8),

            // Category Filter Bar
            const CategoryFilterBar(),

            const SizedBox(height: 8),

            // Habit List
            Expanded(
              child: filteredHabitsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Center(
                  child: Text(
                    'Error: $e',
                    style: AppTextStyles.caption(context),
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
                            style: AppTextStyles.caption(context),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap the + button to add a new habit',
                            style: AppTextStyles.caption(
                              context,
                            ).copyWith(color: colors.textSecondary),
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
                      return HomeHabitTile(habit: habit);
                    },
                  );
                },
              ),
            ),

            // Bottom Navigation Bar
            BottomNavBar(currentItem: BottomNavItem.home),
          ],
        ),
    );
  }
}
