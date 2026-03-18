import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/constants/routes.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/domain/entities/category.dart';
import 'package:habitly/presentation/providers/onboarding_category_provider.dart';
import 'package:habitly/presentation/widgets/habit/category_tile.dart';
import 'package:habitly/presentation/widgets/shared/theme_scaffold.dart';
import 'package:habitly/presentation/widgets/shared/onboarding/onboarding_button_row.dart';
import 'package:habitly/presentation/widgets/shared/onboarding/onboarding_progress_bar.dart';
import 'package:sizer/sizer.dart';

class CategorySelectionPage extends ConsumerWidget {
  const CategorySelectionPage({super.key});

  void _navigateToHabitSelection(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.habitSelection);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryState = ref.watch(onboardingCategoryProvider);
    final categoryNotifier = ref.read(onboardingCategoryProvider.notifier);

    return ThemeScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const OnboardingProgressBar(value: 0.33),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What areas do you want to focus on?',
                  style: AppTextStyles.heading(
                    context,
                  ).copyWith(fontSize: 18.sp),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pick 1-3 categories that matter most',
                  style: AppTextStyles.caption(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 4.sp),
              itemCount: HabitCategory.values.length,
              itemBuilder: (context, index) {
                final category = HabitCategory.values[index];
                final isSelected = categoryState.isSelected(category);

                return CategoryTile(
                  category: category,
                  isSelected: isSelected,
                  onTap: () => categoryNotifier.toggleCategory(category),
                );
              },
            ),
          ),
          OnboardingButtonRow(
            onSkip: () => _navigateToHabitSelection(context),
            onProceed: categoryState.hasSelection
                ? () => _navigateToHabitSelection(context)
                : null,
          ),
        ],
      ),
    );
  }
}
