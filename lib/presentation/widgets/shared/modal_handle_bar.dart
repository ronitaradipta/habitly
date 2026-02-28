import 'package:flutter/material.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:sizer/sizer.dart';

class ModalHandleBar extends StatelessWidget {
  const ModalHandleBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      width: 40.sp,
      height: 4.sp,
      margin: EdgeInsets.only(top: 12.sp, bottom: 8.sp),
      decoration: BoxDecoration(
        color: colors.textSecondary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
