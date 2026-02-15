import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/domain/usecases/get_theme_use_case.dart';
import 'package:habitly/domain/usecases/save_theme_use_case.dart';
import 'package:habitly/injection_container.dart' as di;

class ThemeNotifier extends Notifier<ThemeMode> {
  late final _getThemeUseCase = di.getIt<GetThemeUseCase>();
  late final _saveThemeUseCase = di.getIt<SaveThemeUseCase>();

  @override
  ThemeMode build() {
    _loadTheme();
    return ThemeMode.system;
  }

  Future<void> _loadTheme() async {
    try {
      final savedTheme = await _getThemeUseCase();

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
      await _saveThemeUseCase(mode.name);
    } catch (e) {
      debugPrint('Error saving theme: $e');
    }
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);
