import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:sizer/sizer.dart';

enum FontEngine { local, google }

class FontScale {
  const FontScale();

  // Headings
  static double get h1 => 24.sp;
  static double get h2 => 20.sp;
  static double get h3 => 18.sp;

  // Body text
  static double get body => 16.sp;
  static double get bodySmall => 14.sp;

  // Captions and small text
  static double get caption => 14.sp;
  static double get captionSmall => 12.sp;
  static double get small => 10.sp;

  // Buttons
  static double get buttonLarge => 16.sp;
  static double get button => 14.sp;
}

class AppFonts {
  static TextStyle base({
    required FontEngine engine,
    required double size,
    FontWeight weight = FontWeight.normal,
    double height = 1.4,
    Color? color,
    double? letterSpacing,
  }) {
    if (engine == FontEngine.google) {
      return GoogleFonts.urbanist(
        fontSize: size,
        fontWeight: weight,
        height: height,
        color: color,
        letterSpacing: letterSpacing,
      );
    }

    return TextStyle(
      fontSize: size,
      fontWeight: weight,
      height: height,
      color: color,
      letterSpacing: letterSpacing,
    );
  }
}

class AppTextStyles {
  static TextStyle heading(BuildContext context, FontEngine engine) {
    final c = AppColors.of(context);
    return AppFonts.base(
      engine: engine,
      size: FontScale.h1,
      weight: FontWeight.bold,
      height: 1.3,
      color: c.textPrimary,
      letterSpacing: -0.5,
    );
  }

  static TextStyle headingMedium(BuildContext context, FontEngine engine) {
    final c = AppColors.of(context);
    return AppFonts.base(
      engine: engine,
      size: FontScale.h2,
      weight: FontWeight.bold,
      height: 1.4,
      color: c.textPrimary,
      letterSpacing: -0.3,
    );
  }

  static TextStyle headingSmall(BuildContext context, FontEngine engine) {
    final c = AppColors.of(context);
    return AppFonts.base(
      engine: engine,
      size: FontScale.h3,
      weight: FontWeight.w600,
      height: 1.4,
      color: c.textPrimary,
    );
  }

  static TextStyle subtitle(BuildContext context, FontEngine engine) {
    final c = AppColors.of(context);
    return AppFonts.base(
      engine: engine,
      size: FontScale.body,
      weight: FontWeight.w500,
      height: 1.5,
      color: c.textSecondary,
    );
  }

  static TextStyle body(BuildContext context, FontEngine engine) {
    final c = AppColors.of(context);
    return AppFonts.base(
      engine: engine,
      size: FontScale.body,
      weight: FontWeight.normal,
      height: 1.5,
      color: c.textPrimary,
    );
  }

  static TextStyle bodyBold(BuildContext context, FontEngine engine) {
    final c = AppColors.of(context);
    return AppFonts.base(
      engine: engine,
      size: FontScale.body,
      weight: FontWeight.w600,
      height: 1.5,
      color: c.textPrimary,
    );
  }

  static TextStyle bodySmall(BuildContext context, FontEngine engine) {
    final c = AppColors.of(context);
    return AppFonts.base(
      engine: engine,
      size: FontScale.bodySmall,
      weight: FontWeight.normal,
      height: 1.5,
      color: c.textPrimary,
    );
  }

  static TextStyle caption(BuildContext context, FontEngine engine) {
    final c = AppColors.of(context);
    return AppFonts.base(
      engine: engine,
      size: FontScale.caption,
      weight: FontWeight.normal,
      height: 1.4,
      color: c.textSecondary,
    );
  }

  static TextStyle captionBold(BuildContext context, FontEngine engine) {
    final c = AppColors.of(context);
    return AppFonts.base(
      engine: engine,
      size: FontScale.caption,
      weight: FontWeight.bold,
      height: 1.4,
      color: c.textSecondary,
    );
  }

  static TextStyle captionSmall(BuildContext context, FontEngine engine) {
    final c = AppColors.of(context);
    return AppFonts.base(
      engine: engine,
      size: FontScale.captionSmall,
      weight: FontWeight.normal,
      height: 1.4,
      color: c.textSecondary,
    );
  }

  static TextStyle small(BuildContext context, FontEngine engine) {
    final c = AppColors.of(context);
    return AppFonts.base(
      engine: engine,
      size: FontScale.small,
      weight: FontWeight.normal,
      height: 1.4,
      color: c.textSecondary,
    );
  }

  static TextStyle buttonLarge(BuildContext context, FontEngine engine) {
    final c = AppColors.of(context);
    return AppFonts.base(
      engine: engine,
      size: FontScale.buttonLarge,
      weight: FontWeight.bold,
      height: 1.2,
      color: c.surface,
    );
  }

  static TextStyle button(BuildContext context, FontEngine engine) {
    final c = AppColors.of(context);
    return AppFonts.base(
      engine: engine,
      size: FontScale.button,
      weight: FontWeight.bold,
      height: 1.2,
      color: c.surface,
    );
  }

  static TextStyle buttonOutline(BuildContext context, FontEngine engine) {
    final c = AppColors.of(context);
    return AppFonts.base(
      engine: engine,
      size: FontScale.buttonLarge,
      weight: FontWeight.bold,
      height: 1.2,
      color: c.primary,
    );
  }

  static TextStyle buttonSocial(BuildContext context, FontEngine engine) {
    final c = AppColors.of(context);
    return AppFonts.base(
      engine: engine,
      size: FontScale.bodySmall,
      weight: FontWeight.w600,
      height: 1.2,
      color: c.textPrimary,
    );
  }

  static TextStyle inputLabel(BuildContext context, FontEngine engine) {
    final c = AppColors.of(context);
    return AppFonts.base(
      engine: engine,
      size: FontScale.bodySmall,
      weight: FontWeight.w600,
      height: 1.4,
      color: c.textPrimary,
    );
  }

  static TextStyle inputHint(BuildContext context, FontEngine engine) {
    final c = AppColors.of(context);
    return AppFonts.base(
      engine: engine,
      size: FontScale.body,
      weight: FontWeight.normal,
      height: 1.4,
      color: c.textSecondary,
    );
  }

  static TextStyle inputText(BuildContext context, FontEngine engine) {
    final c = AppColors.of(context);
    return AppFonts.base(
      engine: engine,
      size: FontScale.body,
      weight: FontWeight.normal,
      height: 1.4,
      color: c.textPrimary,
    );
  }

  static TextStyle link(BuildContext context, FontEngine engine) {
    final c = AppColors.of(context);
    return AppFonts.base(
      engine: engine,
      size: FontScale.caption,
      weight: FontWeight.bold,
      height: 1.4,
      color: c.primary,
    );
  }

  static TextStyle linkSmall(BuildContext context, FontEngine engine) {
    final c = AppColors.of(context);
    return AppFonts.base(
      engine: engine,
      size: FontScale.captionSmall,
      weight: FontWeight.bold,
      height: 1.4,
      color: c.primary,
    );
  }

  static TextStyle error(BuildContext context, FontEngine engine) {
    return AppFonts.base(
      engine: engine,
      size: FontScale.captionSmall,
      weight: FontWeight.normal,
      height: 1.4,
      color: Colors.red,
    );
  }

  static TextStyle display(BuildContext context, FontEngine engine) {
    final c = AppColors.of(context);
    return AppFonts.base(
      engine: engine,
      size: 22.sp,
      weight: FontWeight.bold,
      height: 1.2,
      color: c.textPrimary,
      letterSpacing: -0.5,
    );
  }
}
