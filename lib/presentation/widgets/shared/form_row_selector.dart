import 'package:flutter/material.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:sizer/sizer.dart';

class FormRowSelector extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final bool hasValue;
  final VoidCallback onTap;
  final Widget? trailing;

  const FormRowSelector({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.hasValue = false,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.sp),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 20.sp),
            ),
            SizedBox(width: 12.sp),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.caption(
                      context,
                    ).copyWith(color: colors.textSecondary, fontSize: 11.sp),
                  ),
                  SizedBox(height: 2.sp),
                  Text(
                    value,
                    style: AppTextStyles.body(context).copyWith(
                      color: hasValue
                          ? colors.textPrimary
                          : colors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            trailing ??
                Icon(
                  Icons.chevron_right,
                  color: colors.textSecondary,
                  size: 20.sp,
                ),
          ],
        ),
      ),
    );
  }
}
