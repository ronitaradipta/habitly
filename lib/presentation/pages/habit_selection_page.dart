import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/constants/preset_habits.dart';
import 'package:habitly/core/constants/routes.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/domain/entities/category.dart';
import 'package:habitly/domain/usecases/setup_onboarding_habits_use_case.dart';
import 'package:habitly/presentation/providers/habit_provider.dart';
import 'package:habitly/presentation/theme/category_colors.dart';
import 'package:habitly/presentation/theme/icon_mapper.dart';
import 'package:habitly/presentation/providers/habit_selection_provider.dart';
import 'package:habitly/presentation/providers/onboarding_category_provider.dart';
import 'package:habitly/presentation/widgets/shared/theme_scaffold.dart';
import 'package:habitly/presentation/widgets/shared/onboarding/onboarding_button_row.dart';
import 'package:habitly/presentation/widgets/shared/onboarding/onboarding_progress_bar.dart';
import 'package:sizer/sizer.dart';

class HabitSelectionPage extends ConsumerWidget {
  const HabitSelectionPage({super.key});

  Future<void> _proceed(BuildContext context, WidgetRef ref) async {
    final selectionState = ref.read(habitSelectionProvider);
    final notifier = ref.read(habitProvider.notifier);

    final selectedHabitData = selectionState.selectedHabits.map((habitId) {
      final preset = presetHabits.firstWhere((p) => p.id == habitId);
      return OnboardingHabitData(
        name: preset.name,
        iconName: preset.category.iconName,
        categoryId: preset.category.id,
      );
    }).toList();

    await notifier.setupOnboardingHabits(selectedHabitData);

    if (context.mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.reminderTime);
    }
  }

  void _skip(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.reminderTime);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectionState = ref.watch(habitSelectionProvider);
    final selectionNotifier = ref.read(habitSelectionProvider.notifier);
    final categoryState = ref.watch(onboardingCategoryProvider);
    final isLoading = ref.watch(habitProvider).isLoading;

    final categoriesToShow = categoryState.hasSelection
        ? HabitCategory.values
              .where((c) => categoryState.isSelected(c))
              .toList()
        : HabitCategory.values.toList();

    return ThemeScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const OnboardingProgressBar(value: 0.66),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pick habits that inspire you',
                  style: AppTextStyles.heading(
                    context,
                  ).copyWith(fontSize: 18.sp),
                ),
                const SizedBox(height: 4),
                Text(
                  "Select as many as you'd like",
                  style: AppTextStyles.caption(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 8),
              itemCount: categoriesToShow.length,
              itemBuilder: (context, index) {
                final category = categoriesToShow[index];
                final habits = presetHabits
                    .where((h) => h.category == category)
                    .toList();

                return _CategorySection(
                  category: category,
                  habits: habits,
                  selectedHabits: selectionState.selectedHabits,
                  onToggle: selectionNotifier.toggleHabit,
                );
              },
            ),
          ),
          OnboardingButtonRow(
            onSkip: () => _skip(context),
            onProceed: selectionState.hasSelection
                ? () => _proceed(context, ref)
                : null,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  final HabitCategory category;
  final List<PresetHabit> habits;
  final Set<String> selectedHabits;
  final void Function(String) onToggle;

  const _CategorySection({
    required this.category,
    required this.habits,
    required this.selectedHabits,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Color(category.lightColorValue),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  IconMapper.toIconData(category.iconName),
                  color: Color(category.primaryColorValue),
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                category.displayName,
                style: AppTextStyles.bodyBold(
                  context,
                ).copyWith(color: Color(category.primaryColorValue)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: habits.map((habit) {
              final isSelected = selectedHabits.contains(habit.id);
              return _HabitChip(
                habit: habit,
                isSelected: isSelected,
                onTap: () => onToggle(habit.id),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _HabitChip extends StatelessWidget {
  final PresetHabit habit;
  final bool isSelected;
  final VoidCallback onTap;

  const _HabitChip({
    required this.habit,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final categoryColor = Color(habit.category.primaryColorValue);
    final categoryLightColor = Color(habit.category.lightColorValue);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? categoryLightColor : colors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? categoryColor : colors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              Icon(Icons.check_circle, size: 16, color: categoryColor),
              const SizedBox(width: 6),
            ],
            Text(
              habit.name,
              style: AppTextStyles.captionSmall(context).copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? categoryColor : colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
