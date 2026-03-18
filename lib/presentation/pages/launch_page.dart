import 'package:flutter/material.dart';
import 'package:habitly/presentation/widgets/shared/branding/habitly_logo.dart';
import 'package:habitly/presentation/widgets/shared/theme_scaffold.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/core/constants/routes.dart';
import 'package:sizer/sizer.dart';

class LaunchPage extends StatelessWidget {
  const LaunchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return ThemeScaffold(
      body: Column(
        children: [
          // Top section with logo - takes most of the screen
          Expanded(
            flex: 3,
            child: Center(child: HabitLyLogo(size: 28.sp)),
          ),

          // Bottom section with tagline and next button
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Keep up your Health!',
                    style: AppTextStyles.heading(context).copyWith(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Circular Next button with arrow
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.textPrimary, width: 2),
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        color: colors.textPrimary,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
