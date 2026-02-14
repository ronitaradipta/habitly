import 'package:flutter/material.dart';
import 'package:habitly/core/theme/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Scaffold(
      backgroundColor: colors.background,
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
