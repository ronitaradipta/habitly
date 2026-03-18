import 'package:flutter/material.dart';
import 'package:habitly/presentation/widgets/shared/buttons/app_button.dart';

class OnboardingButtonRow extends StatelessWidget {
  final VoidCallback onSkip;
  final VoidCallback? onProceed;
  final String proceedText;
  final bool isLoading;

  const OnboardingButtonRow({
    super.key,
    required this.onSkip,
    this.onProceed,
    this.proceedText = 'Proceed',
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: AppButton(
              text: 'Skip',
              onPressed: isLoading ? null : onSkip,
              variant: AppButtonVariant.outline,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: AppButton(
              text: proceedText,
              onPressed: onProceed,
              isLoading: isLoading,
              variant: AppButtonVariant.primary,
            ),
          ),
        ],
      ),
    );
  }
}
