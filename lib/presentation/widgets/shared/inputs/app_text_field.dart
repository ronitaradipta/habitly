import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/presentation/providers/password_visibility_provider.dart';

enum AppTextFieldBorderStyle { outlined, underline }

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final bool readOnly;
  final AutovalidateMode autovalidateMode;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final AppTextFieldBorderStyle borderStyle;
  final TextStyle? style;

  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.onTap,
    this.readOnly = false,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.maxLines = 1,
    this.textInputAction,
    this.onChanged,
    this.borderStyle = AppTextFieldBorderStyle.outlined,
    this.style,
  });

  InputBorder _buildBorder(
    AppColors colors, {
    Color? overrideColor,
    double width = 1.0,
  }) {
    final color = overrideColor ?? colors.border;
    switch (borderStyle) {
      case AppTextFieldBorderStyle.outlined:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: color, width: width),
        );
      case AppTextFieldBorderStyle.underline:
        return UnderlineInputBorder(
          borderSide: BorderSide(color: color, width: width),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isUnderline = borderStyle == AppTextFieldBorderStyle.underline;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      onTap: onTap,
      readOnly: readOnly,
      autovalidateMode: autovalidateMode,
      maxLines: maxLines,
      textInputAction: textInputAction,
      onChanged: onChanged,
      style: style ?? AppTextStyles.inputText(context, FontEngine.google),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.inputHint(context, FontEngine.google),
        filled: !isUnderline,
        fillColor: isUnderline ? null : colors.surface,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: _buildBorder(colors, overrideColor: colors.textSecondary),
        enabledBorder: _buildBorder(
          colors,
          overrideColor: isUnderline ? colors.textSecondary : colors.border,
        ),
        focusedBorder: _buildBorder(
          colors,
          overrideColor: colors.primary,
          width: 1.5,
        ),
        errorBorder: _buildBorder(colors, overrideColor: colors.error),
        focusedErrorBorder: _buildBorder(
          colors,
          overrideColor: colors.error,
          width: 1.5,
        ),
        contentPadding: isUnderline
            ? null
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

// Password text field with built-in visibility toggle.
class AppPasswordField extends ConsumerWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;
  final ValueChanged<String>? onChanged;
  final String fieldKey;

  const AppPasswordField({
    super.key,
    required this.fieldKey,
    this.controller,
    this.hintText,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final visibilityMap = ref.watch(passwordVisibilityProvider);
    final isVisible = visibilityMap[fieldKey] ?? false;

    return AppTextField(
      controller: controller,
      hintText: hintText,
      obscureText: !isVisible,
      validator: validator,
      autovalidateMode: autovalidateMode,
      onChanged: onChanged,
      suffixIcon: IconButton(
        icon: Icon(
          isVisible ? Icons.visibility : Icons.visibility_off,
          color: colors.textSecondary,
        ),
        onPressed: () {
          ref.read(passwordVisibilityProvider.notifier).toggle(fieldKey);
        },
      ),
    );
  }
}
