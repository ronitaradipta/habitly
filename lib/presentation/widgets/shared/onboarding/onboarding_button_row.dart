import 'package:flutter/material.dart';
import 'package:habitly/presentation/widgets/shared/buttons/app_button.dart';

class OnboardingButtonRow extends StatelessWidget {
  final VoidCallback onSkip;
  final VoidCallback? onProceed;

  const OnboardingButtonRow({super.key, required this.onSkip, this.onProceed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: AppButton(
              text: "Skip",
              onPressed: onSkip,
              variant: AppButtonVariant.outline,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: AppButton(
              text: "Proceed",
              onPressed: onProceed,
              variant: AppButtonVariant.primary,
            ),
          ),
        ],
      ),
    );
  }
}
