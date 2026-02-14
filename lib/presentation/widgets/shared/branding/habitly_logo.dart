import 'package:flutter/material.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:sizer/sizer.dart';

class HabitLyLogo extends StatelessWidget {
  final bool isWhite;
  final double? size;

  const HabitLyLogo({super.key, this.isWhite = false, this.size});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final color = isWhite ? Colors.white : colors.primary;
    final fontSize = size ?? 24.sp;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.energy_savings_leaf, color: color, size: fontSize * 1.2),
        const SizedBox(width: 8),
        Text(
          'HabitLy',
          style: AppTextStyles.heading(
            context,
            FontEngine.google,
          ).copyWith(fontSize: fontSize, color: color),
        ),
      ],
    );
  }
}
