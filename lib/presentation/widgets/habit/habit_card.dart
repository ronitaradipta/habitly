import 'package:flutter/material.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';

class HabitCard extends StatelessWidget {
  final String id;
  final String name;
  final int iconCodePoint;
  final bool isSelected;
  final AppColors colors;
  final VoidCallback onTap;

  const HabitCard({
    super.key,
    required this.id,
    required this.name,
    required this.iconCodePoint,
    required this.isSelected,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: colors.primary, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              IconData(iconCodePoint, fontFamily: 'MaterialIcons'),
              size: 48,
              color: isSelected ? colors.primary : colors.textPrimary,
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: AppTextStyles.body(context, FontEngine.google).copyWith(
                fontWeight: FontWeight.w500,
                color: isSelected ? colors.primary : colors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
