import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/presentation/providers/splash_animation_provider.dart';
import 'package:habitly/presentation/widgets/shared/branding/habitly_logo.dart';
import 'package:habitly/presentation/widgets/shared/theme_scaffold.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncIsExpanded = ref.watch(splashAnimationProvider);
    final isExpanded = asyncIsExpanded.value ?? false;

    return ThemeScaffold(
      showThemeButton: false,
      body: Center(
        child: AnimatedScale(
          scale: isExpanded ? 1.15 : 1.0,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
          child: AnimatedOpacity(
            opacity: isExpanded ? 1.0 : 0.6,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
            child: HabitLyLogo(size: 28.sp),
          ),
        ),
      ),
    );
  }
}
