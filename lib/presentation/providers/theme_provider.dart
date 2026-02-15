import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/presentation/providers/use_case_providers.dart';

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    _loadTheme();
    return ThemeMode.system;
  }

  Future<void> _loadTheme() async {
    try {
      final savedTheme = await ref.read(getThemeUseCaseProvider)();

      final loadedMode = ThemeMode.values.firstWhere(
        (mode) => mode.name == savedTheme,
        orElse: () => ThemeMode.system,
      );

      state = loadedMode;
    } catch (e) {
      state = ThemeMode.system;
    }
  }

  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setTheme(newMode);
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;

    try {
      await ref.read(saveThemeUseCaseProvider)(mode.name);
    } catch (e) {
      debugPrint('Error saving theme: $e');
    }
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);
