import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/presentation/widgets/shared/buttons/app_button.dart';

class SocialAuthSection extends StatelessWidget {
  final VoidCallback? onGooglePressed;
  final VoidCallback? onApplePressed;

  const SocialAuthSection({
    super.key,
    this.onGooglePressed,
    this.onApplePressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: colors.border)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Or', style: AppTextStyles.caption(context)),
            ),
            Expanded(child: Divider(color: colors.border)),
          ],
        ),
        const SizedBox(height: 16),
        AppSocialButton(
          label: 'Continue with Google',
          icon: FontAwesomeIcons.google,
          iconColor: Colors.red,
          onPressed: onGooglePressed ?? () {},
        ),
        const SizedBox(height: 12),
        AppSocialButton(
          label: 'Continue with Apple',
          icon: Icons.apple,
          iconColor: colors.textPrimary,
          onPressed: onApplePressed ?? () {},
        ),
      ],
    );
  }
}
