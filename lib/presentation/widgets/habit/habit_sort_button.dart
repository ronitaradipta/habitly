import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/presentation/providers/habit_sort_provider.dart';

class HabitSortButton extends ConsumerWidget {
  const HabitSortButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final currentSort = ref.watch(habitSortProvider);
    final isActive = currentSort != HabitSortOption.defaultOrder;

    return PopupMenuButton<HabitSortOption>(
      icon: Icon(
        Icons.sort,
        color: isActive ? colors.primary : colors.textSecondary,
      ),
      tooltip: 'Sort habits',
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colors.surface,
      onSelected: (option) {
        ref.read(habitSortProvider.notifier).selectSort(option);
      },
      itemBuilder: (context) => HabitSortOption.values.map((option) {
        final isSelected = option == currentSort;
        return PopupMenuItem<HabitSortOption>(
          value: option,
          child: Row(
            children: [
              Icon(
                option.icon,
                size: 20,
                color: isSelected ? colors.primary : colors.textSecondary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  option.displayName,
                  style: AppTextStyles.bodySmall(context).copyWith(
                    color: isSelected ? colors.primary : colors.textPrimary,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
              if (isSelected)
                Icon(Icons.check, size: 18, color: colors.primary),
            ],
          ),
        );
      }).toList(),
    );
  }
}
