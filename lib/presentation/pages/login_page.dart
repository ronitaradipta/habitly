import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habitly/presentation/providers/auth_provider.dart';
import 'package:habitly/presentation/providers/login_form_provider.dart';
import 'package:habitly/presentation/widgets/shared/buttons/app_button.dart';
import 'package:habitly/presentation/widgets/shared/inputs/app_text_field.dart';
import 'package:habitly/presentation/widgets/shared/branding/habitly_logo.dart';
import 'package:habitly/presentation/widgets/shared/theme_scaffold.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/core/constants/routes.dart';
import 'package:habitly/presentation/utils/auth_result_handler.dart';
import 'package:sizer/sizer.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  Future<void> _continue(
    BuildContext context,
    WidgetRef ref,
    String email,
    String password,
  ) async {
    await ref.read(authProvider.notifier).login(email, password);

    if (context.mounted) {
      handleAuthResult(
        context: context,
        authState: ref.read(authProvider),
        onSuccess: (user) {
          if (user.hasCompletedOnboarding) {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          } else {
            Navigator.pushReplacementNamed(context, AppRoutes.habitSelection);
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final formState = ref.watch(loginFormProvider);
    final formNotifier = ref.read(loginFormProvider.notifier);
    final isLoading = ref.watch(authProvider).isLoading;

    return ThemeScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 8.h),
            HabitLyLogo(size: 24.sp),
            SizedBox(height: 4.h),
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
                  Text("Create one here!", style: AppTextStyles.link(context)),
                ],
              ),
            ),
            SizedBox(height: 4.h),
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
            Text("or", style: AppTextStyles.caption(context)),
            const SizedBox(height: 24),
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text.rich(
                TextSpan(
                  text: "By clicking continue, you agree to our ",
                  style: AppTextStyles.caption(context),
                  children: [
                    TextSpan(
                      text: "Terms of Service",
                      style: AppTextStyles.link(context),
                    ),
                    TextSpan(text: "\nand "),
                    TextSpan(
                      text: "Privacy Policy",
                      style: AppTextStyles.link(context),
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
    );
  }
}
