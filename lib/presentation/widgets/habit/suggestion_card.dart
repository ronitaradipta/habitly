import 'package:flutter/material.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/domain/entities/category.dart';
import 'package:habitly/domain/entities/suggested_habit.dart';
import 'package:habitly/presentation/theme/category_colors.dart';
import 'package:habitly/presentation/theme/icon_mapper.dart';

class SuggestionCard extends StatelessWidget {
  final SuggestedHabit suggestion;
  final bool isSelected;
  final VoidCallback? onTap;

  const SuggestionCard({
    super.key,
    required this.suggestion,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final icon = IconMapper.toIconData(suggestion.iconName);
    final category = HabitCategory.fromId(suggestion.categoryId);
    final categoryColor = category != null
        ? Color(category.primaryColorValue)
        : colors.primary;
    final categoryLightColor = category != null
        ? Color(category.lightColorValue)
        : colors.primary.withValues(alpha: 0.1);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? categoryColor : colors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? categoryColor : Colors.transparent,
                border: Border.all(
                  color: isSelected ? categoryColor : colors.textSecondary,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),

            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: categoryLightColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: categoryColor, size: 22),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    suggestion.name,
                    style: AppTextStyles.bodySmall(context)
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: categoryLightColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          category?.displayName ?? 'Other',
                          style: AppTextStyles.captionSmall(context)
                              .copyWith(
                            color: categoryColor,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        suggestion.frequency,
                        style: AppTextStyles.captionSmall(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    suggestion.reason,
                    style: AppTextStyles.captionSmall(context)
                        .copyWith(color: colors.textSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
