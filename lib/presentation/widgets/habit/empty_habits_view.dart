import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';

class EmptyHabitsView extends StatelessWidget {
  const EmptyHabitsView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/empty_habits.svg',
            width: 120,
            height: 120,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 16),
          Text(
            'No habits for this day',
            style: AppTextStyles.caption(context),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add a new habit',
            style: AppTextStyles.caption(
              context,
            ).copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}
