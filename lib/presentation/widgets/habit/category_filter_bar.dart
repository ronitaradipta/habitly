import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/domain/entities/category.dart';
import 'package:habitly/presentation/providers/filtered_habits_provider.dart';
import 'package:habitly/presentation/providers/selected_category_provider.dart';
import 'package:habitly/presentation/theme/category_colors.dart';
import 'package:habitly/presentation/theme/icon_mapper.dart';

class CategoryFilterBar extends ConsumerWidget {
  const CategoryFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFilteredAsync = ref.watch(dateFilteredHabitsProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return dateFilteredAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (habits) {
        if (habits.isEmpty) return const SizedBox.shrink();

        // Collect unique categories present in date-filtered habits, preserving order
        final categories = <HabitCategory>[];
        for (final habit in habits) {
          final cat = habit.category;
          if (cat != null && !categories.contains(cat)) {
            categories.add(cat);
          }
        }

        return SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              _FilterChip(
                label: 'All',
                icon: Icons.apps,
                isSelected: selectedCategory == null,
                activeColor: AppColors.of(context).primary,
                onTap: () => ref
                    .read(selectedCategoryProvider.notifier)
                    .selectCategory(null),
              ),
              ...categories.map(
                (category) => Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: _FilterChip(
                    label: category.displayName,
                    icon: IconMapper.toIconData(category.iconName),
                    isSelected: selectedCategory == category,
                    activeColor: Color(category.primaryColorValue),
                    onTap: () => ref
                        .read(selectedCategoryProvider.notifier)
                        .selectCategory(category),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final Color activeColor;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? activeColor : colors.border,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? Colors.white : activeColor,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
