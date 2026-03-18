import 'package:habitly/domain/entities/category.dart';

extension CategoryColors on HabitCategory {
  int get primaryColorValue {
    switch (this) {
      case HabitCategory.health:
        return 0xFFB85C5C; // Rosehip
      case HabitCategory.fitness:
        return 0xFF5E8C61; // Fern
      case HabitCategory.career:
        return 0xFF5A7A94; // Slate
      case HabitCategory.finance:
        return 0xFFC2884A; // Amber
      case HabitCategory.learning:
        return 0xFF7D6A8A; // Dried Lavender
      case HabitCategory.relationships:
        return 0xFFB07272; // Dried Rose
      case HabitCategory.productivity:
        return 0xFF6B6089; // Wisteria
      case HabitCategory.hobbies:
        return 0xFFB89B4E; // Marigold
      case HabitCategory.other:
        return 0xFF5E8A84; // Eucalyptus
    }
  }

  int get lightColorValue {
    switch (this) {
      case HabitCategory.health:
        return 0xFFF2DCD8;
      case HabitCategory.fitness:
        return 0xFFD9E8D4;
      case HabitCategory.career:
        return 0xFFD6E2EB;
      case HabitCategory.finance:
        return 0xFFEEDCC8;
      case HabitCategory.learning:
        return 0xFFE0D5E5;
      case HabitCategory.relationships:
        return 0xFFEDDAD8;
      case HabitCategory.productivity:
        return 0xFFDDD6E6;
      case HabitCategory.hobbies:
        return 0xFFEDE3CA;
      case HabitCategory.other:
        return 0xFFD3E2DF;
    }
  }
}
