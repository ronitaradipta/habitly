import 'package:habitly/domain/entities/category.dart';

extension CategoryColors on HabitCategory {
  int get primaryColorValue {
    switch (this) {
      case HabitCategory.health:
        return 0xFFE53935; // Red
      case HabitCategory.fitness:
        return 0xFF43A047; // Green
      case HabitCategory.career:
        return 0xFF1E88E5; // Blue
      case HabitCategory.finance:
        return 0xFFFB8C00; // Orange
      case HabitCategory.learning:
        return 0xFF8E24AA; // Purple
      case HabitCategory.relationships:
        return 0xFFE91E63; // Pink
      case HabitCategory.productivity:
        return 0xFF5E35B1; // Deep Purple
      case HabitCategory.hobbies:
        return 0xFFFFB300; // Amber
      case HabitCategory.other:
        return 0xFF009688; // Teal
    }
  }

  int get lightColorValue {
    switch (this) {
      case HabitCategory.health:
        return 0xFFFFCDD2; // Light Red
      case HabitCategory.fitness:
        return 0xFFC8E6C9; // Light Green
      case HabitCategory.career:
        return 0xFFBBDEFB; // Light Blue
      case HabitCategory.finance:
        return 0xFFFFE0B2; // Light Orange
      case HabitCategory.learning:
        return 0xFFE1BEE7; // Light Purple
      case HabitCategory.relationships:
        return 0xFFF8BBD0; // Light Pink
      case HabitCategory.productivity:
        return 0xFFD1C4E9; // Light Deep Purple
      case HabitCategory.hobbies:
        return 0xFFFFECB3; // Light Amber
      case HabitCategory.other:
        return 0xFFB2DFDB; // Light Teal
    }
  }
}
