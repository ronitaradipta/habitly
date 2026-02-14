import 'package:flutter/material.dart';

class AppColors {
  final Color background;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final Color primary;
  final Color border;
  final Color error;
  final Color disabled;

  const AppColors({
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.primary,
    required this.border,
    required this.error,
    required this.disabled,
  });

  static AppColors of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? dark : light;
  }

  static const light = AppColors(
    background: Color(0xFFE3FFDB),
    surface: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF1A1A1A),
    textSecondary: Color(0xFF6B7280),
    primary: Color(0xFF2FB969),
    border: Color(0xFFE0E0E0),
    error: Color(0xFFE53935),
    disabled: Color(0xFFBDBDBD),
  );

  static const dark = AppColors(
    background: Color(0xFF181A20),
    surface: Color(0xFF262A34),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFF8D8D98),
    primary: Color(0xFF2FB969),
    border: Color(0xFF404040),
    error: Color(0xFFEF5350),
    disabled: Color(0xFF616161),
  );
}
