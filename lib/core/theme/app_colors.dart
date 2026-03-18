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
  final Color dateBlue;
  final Color dateOrange;

  const AppColors({
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.primary,
    required this.border,
    required this.error,
    required this.disabled,
    required this.dateBlue,
    required this.dateOrange,
  });

  static AppColors of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? dark : light;
  }

  static const light = AppColors(
    background: Color(0xFFF6F3EE), // Warm Parchment
    surface: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF2D2A26), // Warm Charcoal
    textSecondary: Color(0xFF8C8379), // Warm Stone
    primary: Color(0xFF4A7C59), // Forest Sage
    border: Color(0xFFDDD7CF), // Sand
    error: Color(0xFFC4554D), // Terracotta Red
    disabled: Color(0xFFC5BEB6), // Driftwood
    dateBlue: Color(0xFF5B7FA6), // Slate Blue
    dateOrange: Color(0xFFC8864E), // Amber Clay
  );

  static const dark = AppColors(
    background: Color(0xFF1A1816), // Deep Loam
    surface: Color(0xFF282420), // Dark Bark
    textPrimary: Color(0xFFF0EBE3), // Cream White
    textSecondary: Color(0xFF9C9488), // Sandstone
    primary: Color(0xFF6DAF7B), // Light Sage
    border: Color(0xFF3D3733), // Shadow Bark
    error: Color(0xFFD4736C), // Faded Terracotta
    disabled: Color(0xFF5A5349), // Weathered Wood
    dateBlue: Color(0xFF7FA3C4), // Faded Denim
    dateOrange: Color(0xFFD4A06A), // Honey Amber
  );
}
