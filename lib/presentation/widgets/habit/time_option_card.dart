import 'package:flutter/material.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:sizer/sizer.dart';

class TimeOptionCard extends StatelessWidget {
  final String id;
  final String time;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const TimeOptionCard({
    super.key,
    required this.id,
    required this.time,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
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
            Text(
              time,
              style: AppTextStyles.heading(context).copyWith(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: isSelected ? colors.primary : colors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.body(context).copyWith(
                color: isSelected ? colors.primary : colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
