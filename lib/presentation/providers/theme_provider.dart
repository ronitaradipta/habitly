import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/presentation/providers/use_case_providers.dart';

class ThemeNotifier extends AsyncNotifier<ThemeMode> {
  @override
  Future<ThemeMode> build() async {
    try {
      final savedTheme = await ref.read(getThemeUseCaseProvider)();

      return ThemeMode.values.firstWhere(
        (mode) => mode.name == savedTheme,
        orElse: () => ThemeMode.system,
      );
    } catch (e) {
      return ThemeMode.system;
    }
  }

  Future<void> toggleTheme() async {
    final current = state.asData?.value ?? ThemeMode.system;
    final newMode = current == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setTheme(newMode);
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = AsyncData(mode);

    try {
      await ref.read(saveThemeUseCaseProvider)(mode.name);
    } catch (e) {
      debugPrint('Error saving theme: $e');
    }
  }
}

final themeProvider = AsyncNotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);
