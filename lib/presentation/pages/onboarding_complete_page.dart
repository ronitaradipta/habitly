import 'package:flutter/material.dart';
import 'package:habitly/presentation/widgets/shared/buttons/app_button.dart';
import 'package:habitly/presentation/widgets/shared/buttons/theme_switch_button.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/core/constants/routes.dart';
import 'package:sizer/sizer.dart';

class OnboardingCompletePage extends StatelessWidget {
  const OnboardingCompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Success icon
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle_outline,
                        size: 60,
                        color: colors.primary,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Congrats message
                    Text(
                      "Congrats, you are all set!",
                      style: AppTextStyles.heading(
                        context,
                      ).copyWith(fontSize: 20.sp),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),

                    // Subtitle
                    Text(
                      "Start tracking your habits and build a healthier lifestyle.",
                      style: AppTextStyles.caption(context),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),

                    // Start Tracking button
                    AppButton(
                      text: "Start Tracking",
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, AppRoutes.home);
                      },
                      variant: AppButtonVariant.primary,
                    ),
                  ],
                ),
              ),
            ),
            const Positioned(top: 16, right: 16, child: ThemeSwitchButton()),
          ],
        ),
      ),
    );
  }
}
