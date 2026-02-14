import 'package:flutter/material.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';

enum AppButtonVariant { primary, secondary, outline, dark }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isExpanded = true,
    this.fontSize,
  });

  final String text;
  final VoidCallback? onPressed;

  final AppButtonVariant variant;
  final bool isExpanded;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final effectiveFontSize = fontSize ?? 16.0;

    Widget button;

    switch (variant) {
      case AppButtonVariant.primary:
        button = ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
          ),
          child: Text(
            text,
            style: AppTextStyles.button(
              context,
              FontEngine.google,
            ).copyWith(fontSize: effectiveFontSize),
          ),
        );
        break;

      case AppButtonVariant.secondary:
        button = ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.border,
            foregroundColor: colors.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
          ),
          child: Text(
            text,
            style: AppTextStyles.button(
              context,
              FontEngine.google,
            ).copyWith(fontSize: effectiveFontSize, color: colors.primary),
          ),
        );
        break;

      case AppButtonVariant.outline:
        button = OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            side: BorderSide(color: colors.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            text,
            style: AppTextStyles.button(
              context,
              FontEngine.google,
            ).copyWith(fontSize: effectiveFontSize, color: colors.primary),
          ),
        );
        break;

      case AppButtonVariant.dark:
        button = ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.textPrimary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
          ),
          child: Text(
            text,
            style: AppTextStyles.button(
              context,
              FontEngine.google,
            ).copyWith(fontSize: effectiveFontSize),
          ),
        );
        break;
    }

    if (isExpanded) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}

// Social login button with an icon (e.g., Google, Apple).
class AppSocialButton extends StatelessWidget {
  const AppSocialButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.iconColor,
  });

  // Button text label
  final String label;

  // Icon to display
  final IconData icon;

  // Callback when button is pressed
  final VoidCallback? onPressed;

  // Optional icon color
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: BorderSide(color: colors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: colors.surface,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor ?? colors.textPrimary, size: 24),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.buttonSocial(context, FontEngine.google),
            ),
          ],
        ),
      ),
    );
  }
}
