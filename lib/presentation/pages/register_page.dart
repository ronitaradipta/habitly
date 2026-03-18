import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/presentation/providers/auth_provider.dart';
import 'package:habitly/presentation/providers/register_form_provider.dart';
import 'package:habitly/presentation/widgets/shared/buttons/app_button.dart';
import 'package:habitly/presentation/widgets/shared/inputs/app_dropdown.dart';
import 'package:habitly/presentation/widgets/shared/inputs/app_phone_field.dart';
import 'package:habitly/presentation/widgets/shared/inputs/app_text_field.dart';
import 'package:habitly/presentation/widgets/shared/auth/social_auth_section.dart';
import 'package:habitly/presentation/widgets/shared/branding/habitly_logo.dart';
import 'package:habitly/presentation/widgets/shared/inputs/input_label.dart';
import 'package:habitly/presentation/widgets/shared/theme_scaffold.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/core/constants/routes.dart';
import 'package:habitly/presentation/utils/auth_result_handler.dart';
import 'package:sizer/sizer.dart';

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  Future<void> _register(
    BuildContext context,
    WidgetRef ref,
    RegisterFormState formState,
  ) async {
    await ref
        .read(authProvider.notifier)
        .register(
          email: formState.email,
          fullName: formState.fullName,
          mobile: formState.mobile,
          gender: formState.selectedGender,
          password: formState.password,
        );

    if (context.mounted) {
      handleAuthResult(
        context: context,
        authState: ref.read(authProvider),
        onSuccess: (user) {
          Navigator.pushReplacementNamed(context, AppRoutes.onboardingMethod);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final formState = ref.watch(registerFormProvider);
    final formNotifier = ref.read(registerFormProvider.notifier);
    final isLoading = ref.watch(authProvider).isLoading;

    return ThemeScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 4.h),
            HabitLyLogo(size: 20.sp),
            SizedBox(height: 3.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text(
                      'Account Register',
                      style: AppTextStyles.heading(
                        context,
                      ).copyWith(fontSize: 18.sp),
                    ),
                  ),
                  const SizedBox(height: 24),
                  InputLabel(label: 'Full Name'),
                  const SizedBox(height: 8),
                  AppTextField(
                    hintText: '',
                    onChanged: formNotifier.updateFullName,
                    validator: (_) => formState.fullNameError,
                  ),
                  const SizedBox(height: 16),
                  InputLabel(label: 'Email'),
                  const SizedBox(height: 8),
                  AppTextField(
                    hintText: '',
                    keyboardType: TextInputType.emailAddress,
                    onChanged: formNotifier.updateEmail,
                    validator: (_) => formState.emailError,
                  ),
                  const SizedBox(height: 16),
                  InputLabel(label: 'Gender'),
                  const SizedBox(height: 8),
                  AppDropdown<String>(
                    value: formState.selectedGender,
                    items: ['Male', 'Female'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        formNotifier.updateGender(newValue);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  InputLabel(label: 'Mobile'),
                  const SizedBox(height: 8),
                  AppPhoneField(
                    onChanged: formNotifier.updateMobile,
                    validator: (_) => formState.mobileError,
                  ),
                  const SizedBox(height: 16),
                  InputLabel(label: 'Password'),
                  const SizedBox(height: 8),
                  AppPasswordField(
                    fieldKey: 'register_password',
                    onChanged: formNotifier.updatePassword,
                    validator: (_) => formState.passwordError,
                  ),
                  const SizedBox(height: 16),
                  InputLabel(label: 'Confirm Password'),
                  const SizedBox(height: 8),
                  AppPasswordField(
                    fieldKey: 'register_confirmPassword',
                    onChanged: formNotifier.updateConfirmPassword,
                    validator: (_) => formState.confirmPasswordError,
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    text: 'Register',
                    isLoading: isLoading,
                    onPressed: formState.isValid
                        ? () => _register(context, ref, formState)
                        : null,
                    variant: AppButtonVariant.primary,
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    text: 'Login',
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.login),
                    variant: AppButtonVariant.secondary,
                  ),
                  const SizedBox(height: 16),
                  const SocialAuthSection(),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
