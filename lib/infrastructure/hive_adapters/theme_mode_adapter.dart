import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'type_ids.dart';

class ThemeModeAdapter extends TypeAdapter<ThemeMode> {
  @override
  final int typeId = HiveTypeIds.themeMode;

  @override
  ThemeMode read(BinaryReader reader) {
    final modeString = reader.read() as String;

    return ThemeMode.values.firstWhere(
      (mode) => mode.name == modeString,
      orElse: () => ThemeMode.system,
    );
  }

  @override
  void write(BinaryWriter writer, ThemeMode obj) {
    writer.write(obj.name);
  }
}
