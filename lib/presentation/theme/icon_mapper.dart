import 'package:flutter/material.dart';

class IconMapper {
  IconMapper._();

  static const String defaultIconName = 'fitness_center';

  static const Map<String, IconData> _icons = {
    'favorite': Icons.favorite,
    'fitness_center': Icons.fitness_center,
    'work': Icons.work,
    'attach_money': Icons.attach_money,
    'school': Icons.school,
    'people': Icons.people,
    'task_alt': Icons.task_alt,
    'palette': Icons.palette,
    'interests': Icons.interests,
  };

  static IconData toIconData(String iconName) {
    return _icons[iconName] ?? _icons[defaultIconName]!;
  }
}
