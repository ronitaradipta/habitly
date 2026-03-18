import 'package:flutter/material.dart';
import 'package:habitly/core/constants/routes.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/presentation/widgets/shared/theme_scaffold.dart';
import 'package:sizer/sizer.dart';

class OnboardingMethodPage extends StatelessWidget {
  const OnboardingMethodPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return ThemeScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 6.h),
              Text(
                "How would you like to set up\nyour habits?",
                style: AppTextStyles.heading(context).copyWith(fontSize: 18.sp),
              ),
              const SizedBox(height: 8),
              Text(
                "Choose your preferred onboarding method",
                style: AppTextStyles.caption(context),
              ),
              SizedBox(height: 5.h),
              _MethodCard(
                icon: Icons.checklist_rounded,
                title: "Manual Setup",
                description:
                    "Pick categories and habits yourself from our curated list.",
                colors: colors,
                onTap: () => Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.categorySelection,
                ),
              ),
              const SizedBox(height: 16),
              _MethodCard(
                icon: Icons.auto_awesome,
                title: "AI-Powered",
                description:
                    "Describe your goals and let AI suggest personalized habits for you.",
                colors: colors,
                onTap: () => Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.aiOnboarding,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MethodCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final AppColors colors;
  final VoidCallback onTap;

  const _MethodCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: colors.primary, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyBold(context),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTextStyles.captionSmall(context)
                        .copyWith(color: colors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              color: colors.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
