import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/presentation/providers/theme_provider.dart';
import 'package:habitly/core/theme/app_colors.dart';

class ThemeSwitchButton extends ConsumerWidget {
  const ThemeSwitchButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider).asData?.value ?? ThemeMode.system;
    final colors = AppColors.of(context);

    return IconButton(
      onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
      icon: Icon(
        themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
        color: colors.textPrimary,
      ),
      tooltip: themeMode == ThemeMode.dark
          ? 'Switch to Light Mode'
          : 'Switch to Dark Mode',
    );
  }
}
