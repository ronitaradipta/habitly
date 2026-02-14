import 'package:flutter/material.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';

class TimePeriodButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const TimePeriodButton({
    super.key,
    required this.label,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: isSelected
              ? null
              : Border.all(color: colors.primary, width: 2),
        ),
        child: Text(
          label,
          style: AppTextStyles.body(context, FontEngine.google).copyWith(
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : colors.primary,
          ),
        ),
      ),
    );
  }
}
