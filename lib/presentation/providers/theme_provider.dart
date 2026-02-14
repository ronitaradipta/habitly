import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/infrastructure/hive_constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeState {
  final ThemeMode mode;

  const ThemeState({this.mode = ThemeMode.system});

  bool get isDarkMode => mode == ThemeMode.dark;
  bool get isLightMode => mode == ThemeMode.light;
  bool get isSystemMode => mode == ThemeMode.system;

  ThemeState copyWith({ThemeMode? mode}) {
    return ThemeState(mode: mode ?? this.mode);
  }
}

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    try {
      final box = Hive.box(HiveConstants.themeBox);
      final savedTheme = box.get(
        HiveConstants.themeKey,
        defaultValue: 'system',
      );

      final loadedMode = ThemeMode.values.firstWhere(
        (mode) => mode.name == savedTheme,
        orElse: () => ThemeMode.system,
      );

      return loadedMode;
    } catch (e) {
      // If loading fails, use system default
      return ThemeMode.system;
    }
  }

  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setTheme(newMode);
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;

    try {
      final box = Hive.box(HiveConstants.themeBox);
      await box.put(HiveConstants.themeKey, mode.name);
    } catch (e) {
      // Log error but don't crash - state update already happened
      debugPrint('Error saving theme to Hive: $e');
    }
  }

  bool get isDarkMode => state == ThemeMode.dark;
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);
