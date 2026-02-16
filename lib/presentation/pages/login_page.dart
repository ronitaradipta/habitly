import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habitly/presentation/providers/auth_provider.dart';
import 'package:habitly/presentation/providers/login_form_provider.dart';
import 'package:habitly/presentation/widgets/shared/buttons/app_button.dart';
import 'package:habitly/presentation/widgets/shared/inputs/app_text_field.dart';
import 'package:habitly/presentation/widgets/shared/branding/habitly_logo.dart';
import 'package:habitly/presentation/widgets/shared/buttons/theme_switch_button.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/core/constants/routes.dart';
import 'package:sizer/sizer.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  Future<void> _continue(
    BuildContext context,
    WidgetRef ref,
    String email,
    String password,
  ) async {
    final authNotifier = ref.read(authProvider.notifier);

    await authNotifier.login(email, password);

    // Check auth state for navigation
    final authState = ref.read(authProvider);
    if (context.mounted) {
      authState.when(
        data: (user) {
          if (user != null) {
            if (user.hasCompletedOnboarding) {
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            } else {
              Navigator.pushReplacementNamed(context, AppRoutes.habitSelection);
            }
          }
        },
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString().replaceAll('Exception: ', '')),
              backgroundColor: AppColors.of(context).error,
            ),
          );
        },
        loading: () {},
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final formState = ref.watch(loginFormProvider);
    final formNotifier = ref.read(loginFormProvider.notifier);
    final isLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  // Logo section
                  SizedBox(height: 8.h),
                  HabitLyLogo(size: 24.sp),
                  SizedBox(height: 4.h),

                  // "Didn't have account?" section
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.register);
                    },
                    child: Column(
                      children: [
                        Text(
                          "Didn't have account ?",
                          style: AppTextStyles.heading(
                            context,
                          ).copyWith(fontSize: 20.sp),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Create one here!",
                          style: AppTextStyles.link(context),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),

                  // Email input field with validation
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: AppTextField(
                      keyboardType: TextInputType.emailAddress,
                      hintText: "email@domain.com",
                      onChanged: formNotifier.updateEmail,
                      validator: (_) => formState.emailError,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password input field
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: AppPasswordField(
                      fieldKey: "login_password",
                      hintText: "Password",
                      onChanged: formNotifier.updatePassword,
                      validator: (_) => formState.passwordError,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Continue button - disabled when form is invalid
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: AppButton(
                      text: "Continue",
                      isLoading: isLoading,
                      onPressed: formState.isValid
                          ? () => _continue(
                              context,
                              ref,
                              formState.email,
                              formState.password,
                            )
                          : null,
                      variant: AppButtonVariant.primary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // "or" divider
                  Text(
                    "or",
                    style: AppTextStyles.caption(context),
                  ),
                  const SizedBox(height: 24),

                  // Continue with Google button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: AppSocialButton(
                      label: "Continue with Google",
                      icon: FontAwesomeIcons.google,
                      iconColor: Colors.red,
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Continue with Apple button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: AppSocialButton(
                      label: "Continue with Apple",
                      icon: Icons.apple,
                      iconColor: colors.textPrimary,
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(height: 4.h),

                  // Terms of Service text
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text.rich(
                      TextSpan(
                        text: "By clicking continue, you agree to our ",
                        style: AppTextStyles.caption(
                          context,
                        ),
                        children: [
                          TextSpan(
                            text: "Terms of Service",
                            style: AppTextStyles.link(
                              context,
                            ),
                          ),
                          TextSpan(text: "\nand "),
                          TextSpan(
                            text: "Privacy Policy",
                            style: AppTextStyles.link(
                              context,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
            const Positioned(top: 16, right: 16, child: ThemeSwitchButton()),
          ],
        ),
      ),
    );
  }
}
