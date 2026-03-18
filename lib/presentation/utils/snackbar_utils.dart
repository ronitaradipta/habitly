import 'package:flutter/material.dart';
import 'package:habitly/core/theme/app_colors.dart';

class AppSnackBar {
  AppSnackBar._();

  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  static void showError(BuildContext context, String message) {
    final colors = AppColors.of(context);
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: colors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  static void showSuccess(BuildContext context, String message) {
    final colors = AppColors.of(context);
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: colors.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
