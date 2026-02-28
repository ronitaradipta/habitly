import 'package:flutter/material.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/presentation/widgets/shared/selectable_card.dart';
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
    return SelectableCard(
      isSelected: isSelected,
      onTap: onTap,
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
    );
  }
}
