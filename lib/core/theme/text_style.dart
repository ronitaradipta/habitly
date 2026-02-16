import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:sizer/sizer.dart';

class FontScale {
  const FontScale();

  static double get h1 => 24.sp;
  static double get h2 => 20.sp;
  static double get h3 => 18.sp;

  static double get body => 16.sp;
  static double get bodySmall => 14.sp;

  static double get caption => 14.sp;
  static double get captionSmall => 12.sp;
  static double get small => 10.sp;

  static double get buttonLarge => 16.sp;
  static double get button => 14.sp;
}

class AppFonts {
  static TextStyle base({
    required double size,
    FontWeight weight = FontWeight.normal,
    double height = 1.4,
    Color? color,
    double? letterSpacing,
  }) {
    return GoogleFonts.urbanist(
      fontSize: size,
      fontWeight: weight,
      height: height,
      color: color,
      letterSpacing: letterSpacing,
    );
  }
}

class AppTextStyles {
  static TextStyle heading(BuildContext context) {
    final c = AppColors.of(context);
    return AppFonts.base(
      size: FontScale.h1,
      weight: FontWeight.bold,
      height: 1.3,
      color: c.textPrimary,
      letterSpacing: -0.5,
    );
  }

  static TextStyle headingMedium(BuildContext context) {
    final c = AppColors.of(context);
    return AppFonts.base(
      size: FontScale.h2,
      weight: FontWeight.bold,
      height: 1.4,
      color: c.textPrimary,
      letterSpacing: -0.3,
    );
  }

  static TextStyle headingSmall(BuildContext context) {
    final c = AppColors.of(context);
    return AppFonts.base(
      size: FontScale.h3,
      weight: FontWeight.w600,
      height: 1.4,
      color: c.textPrimary,
    );
  }

  static TextStyle subtitle(BuildContext context) {
    final c = AppColors.of(context);
    return AppFonts.base(
      size: FontScale.body,
      weight: FontWeight.w500,
      height: 1.5,
      color: c.textSecondary,
    );
  }

  static TextStyle body(BuildContext context) {
    final c = AppColors.of(context);
    return AppFonts.base(
      size: FontScale.body,
      weight: FontWeight.normal,
      height: 1.5,
      color: c.textPrimary,
    );
  }

  static TextStyle bodyBold(BuildContext context) {
    final c = AppColors.of(context);
    return AppFonts.base(
      size: FontScale.body,
      weight: FontWeight.w600,
      height: 1.5,
      color: c.textPrimary,
    );
  }

  static TextStyle bodySmall(BuildContext context) {
    final c = AppColors.of(context);
    return AppFonts.base(
      size: FontScale.bodySmall,
      weight: FontWeight.normal,
      height: 1.5,
      color: c.textPrimary,
    );
  }

  static TextStyle caption(BuildContext context) {
    final c = AppColors.of(context);
    return AppFonts.base(
      size: FontScale.caption,
      weight: FontWeight.normal,
      height: 1.4,
      color: c.textSecondary,
    );
  }

  static TextStyle captionBold(BuildContext context) {
    final c = AppColors.of(context);
    return AppFonts.base(
      size: FontScale.caption,
      weight: FontWeight.bold,
      height: 1.4,
      color: c.textSecondary,
    );
  }

  static TextStyle captionSmall(BuildContext context) {
    final c = AppColors.of(context);
    return AppFonts.base(
      size: FontScale.captionSmall,
      weight: FontWeight.normal,
      height: 1.4,
      color: c.textSecondary,
    );
  }

  static TextStyle small(BuildContext context) {
    final c = AppColors.of(context);
    return AppFonts.base(
      size: FontScale.small,
      weight: FontWeight.normal,
      height: 1.4,
      color: c.textSecondary,
    );
  }

  static TextStyle buttonLarge(BuildContext context) {
    final c = AppColors.of(context);
    return AppFonts.base(
      size: FontScale.buttonLarge,
      weight: FontWeight.bold,
      height: 1.2,
      color: c.surface,
    );
  }

  static TextStyle button(BuildContext context) {
    final c = AppColors.of(context);
    return AppFonts.base(
      size: FontScale.button,
      weight: FontWeight.bold,
      height: 1.2,
      color: c.surface,
    );
  }

  static TextStyle buttonOutline(BuildContext context) {
    final c = AppColors.of(context);
    return AppFonts.base(
      size: FontScale.buttonLarge,
      weight: FontWeight.bold,
      height: 1.2,
      color: c.primary,
    );
  }

  static TextStyle buttonSocial(BuildContext context) {
    final c = AppColors.of(context);
    return AppFonts.base(
      size: FontScale.bodySmall,
      weight: FontWeight.w600,
      height: 1.2,
      color: c.textPrimary,
    );
  }

  static TextStyle inputLabel(BuildContext context) {
    final c = AppColors.of(context);
    return AppFonts.base(
      size: FontScale.bodySmall,
      weight: FontWeight.w600,
      height: 1.4,
      color: c.textPrimary,
    );
  }

  static TextStyle inputHint(BuildContext context) {
    final c = AppColors.of(context);
    return AppFonts.base(
      size: FontScale.body,
      weight: FontWeight.normal,
      height: 1.4,
      color: c.textSecondary,
    );
  }

  static TextStyle inputText(BuildContext context) {
    final c = AppColors.of(context);
    return AppFonts.base(
      size: FontScale.body,
      weight: FontWeight.normal,
      height: 1.4,
      color: c.textPrimary,
    );
  }

  static TextStyle link(BuildContext context) {
    final c = AppColors.of(context);
    return AppFonts.base(
      size: FontScale.caption,
      weight: FontWeight.bold,
      height: 1.4,
      color: c.primary,
    );
  }

  static TextStyle linkSmall(BuildContext context) {
    final c = AppColors.of(context);
    return AppFonts.base(
      size: FontScale.captionSmall,
      weight: FontWeight.bold,
      height: 1.4,
      color: c.primary,
    );
  }

  static TextStyle error(BuildContext context) {
    return AppFonts.base(
      size: FontScale.captionSmall,
      weight: FontWeight.normal,
      height: 1.4,
      color: Colors.red,
    );
  }

  static TextStyle display(BuildContext context) {
    final c = AppColors.of(context);
    return AppFonts.base(
      size: 22.sp,
      weight: FontWeight.bold,
      height: 1.2,
      color: c.textPrimary,
      letterSpacing: -0.5,
    );
  }
}
