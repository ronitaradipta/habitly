import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habitly/presentation/providers/auth_provider.dart';
import 'package:habitly/presentation/providers/register_form_provider.dart';
import 'package:habitly/presentation/widgets/shared/buttons/app_button.dart';
import 'package:habitly/presentation/widgets/shared/inputs/app_dropdown.dart';
import 'package:habitly/presentation/widgets/shared/inputs/app_phone_field.dart';
import 'package:habitly/presentation/widgets/shared/inputs/app_text_field.dart';
import 'package:habitly/presentation/widgets/shared/branding/habitly_logo.dart';
import 'package:habitly/presentation/widgets/shared/inputs/input_label.dart';
import 'package:habitly/presentation/widgets/shared/buttons/theme_switch_button.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/core/constants/routes.dart';
import 'package:sizer/sizer.dart';

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  Future<void> _register(
    BuildContext context,
    WidgetRef ref,
    RegisterFormState formState,
  ) async {
    final authNotifier = ref.read(authProvider.notifier);

    await authNotifier.register(
      email: formState.email,
      fullName: formState.fullName,
      mobile: formState.mobile,
      gender: formState.selectedGender,
      password: formState.password,
    );

    final authState = ref.read(authProvider);
    if (context.mounted) {
      authState.when(
        data: (user) {
          if (user != null) {
            Navigator.pushReplacementNamed(context, AppRoutes.habitSelection);
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
    final formState = ref.watch(registerFormProvider);
    final formNotifier = ref.read(registerFormProvider.notifier);
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
                  SizedBox(height: 4.h),
                  HabitLyLogo(size: 20.sp),
                  SizedBox(height: 3.h),

                  // White form card
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
                        // Account Register heading
                        Center(
                          child: Text(
                            "Account Register",
                            style: AppTextStyles.heading(
                              context,
                            ).copyWith(fontSize: 18.sp),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Full Name field
                        InputLabel(label: "Full Name"),
                        const SizedBox(height: 8),
                        AppTextField(
                          hintText: "",
                          onChanged: formNotifier.updateFullName,
                          validator: (_) => formState.fullNameError,
                        ),
                        const SizedBox(height: 16),

                        // Email field
                        InputLabel(label: "Email"),
                        const SizedBox(height: 8),
                        AppTextField(
                          hintText: "",
                          keyboardType: TextInputType.emailAddress,
                          onChanged: formNotifier.updateEmail,
                          validator: (_) => formState.emailError,
                        ),
                        const SizedBox(height: 16),

                        // Gender field
                        InputLabel(label: "Jenis Kelamin"),
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

                        // Mobile field
                        InputLabel(label: "Mobile"),
                        const SizedBox(height: 8),
                        AppPhoneField(
                          onChanged: formNotifier.updateMobile,
                          validator: (_) => formState.mobileError,
                        ),
                        const SizedBox(height: 16),

                        // Password field
                        InputLabel(label: "Password"),
                        const SizedBox(height: 8),
                        AppPasswordField(
                          fieldKey: 'register_password',
                          onChanged: formNotifier.updatePassword,
                          validator: (_) => formState.passwordError,
                        ),
                        const SizedBox(height: 16),

                        // Confirm Password field
                        InputLabel(label: "Confirm Password"),
                        const SizedBox(height: 8),
                        AppPasswordField(
                          fieldKey: 'register_confirmPassword',
                          onChanged: formNotifier.updateConfirmPassword,
                          validator: (_) => formState.confirmPasswordError,
                        ),

                        // Forgot Password link
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              "Forgot Password?",
                              style: AppTextStyles.caption(
                                context,
                              ).copyWith(fontSize: 12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Register button - disabled when form is invalid
                        AppButton(
                          text: "Register",
                          isLoading: isLoading,
                          onPressed: formState.isValid
                              ? () => _register(context, ref, formState)
                              : null,
                          variant: AppButtonVariant.primary,
                        ),
                        const SizedBox(height: 12),

                        // Login button
                        AppButton(
                          text: "Login",
                          onPressed: () =>
                              Navigator.pushNamed(context, AppRoutes.login),
                          variant: AppButtonVariant.secondary,
                        ),
                        const SizedBox(height: 16),

                        // Or divider
                        Row(
                          children: [
                            Expanded(child: Divider(color: colors.border)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                "Or",
                                style: AppTextStyles.caption(
                                  context,
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: colors.border)),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Sign in with Google
                        AppSocialButton(
                          label: "Sign in with Google",
                          icon: FontAwesomeIcons.google,
                          iconColor: Colors.red,
                          onPressed: () {},
                        ),
                        const SizedBox(height: 16),

                        // Sign in with Apple
                        AppSocialButton(
                          label: "Sign in with Apple",
                          icon: Icons.apple,
                          iconColor: colors.textPrimary,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
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
