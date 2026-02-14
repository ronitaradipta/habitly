import 'package:flutter/material.dart';
import 'package:habitly/core/theme/app_colors.dart';

class OnboardingProgressBar extends StatelessWidget {
  final double value;

  const OnboardingProgressBar({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: colors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: colors.border,
              valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}
