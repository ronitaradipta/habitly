enum HabitCategory {
  health,
  fitness,
  career,
  finance,
  learning,
  relationships,
  productivity,
  hobbies,
  other;

  String get id => name;

  String get displayName {
    switch (this) {
      case HabitCategory.health:
        return 'Health';
      case HabitCategory.fitness:
        return 'Fitness';
      case HabitCategory.career:
        return 'Career';
      case HabitCategory.finance:
        return 'Finance';
      case HabitCategory.learning:
        return 'Learning';
      case HabitCategory.relationships:
        return 'Relationships';
      case HabitCategory.productivity:
        return 'Productivity';
      case HabitCategory.hobbies:
        return 'Hobbies';
      case HabitCategory.other:
        return 'Other';
    }
  }

  String get iconName {
    switch (this) {
      case HabitCategory.health:
        return 'favorite';
      case HabitCategory.fitness:
        return 'fitness_center';
      case HabitCategory.career:
        return 'work';
      case HabitCategory.finance:
        return 'attach_money';
      case HabitCategory.learning:
        return 'school';
      case HabitCategory.relationships:
        return 'people';
      case HabitCategory.productivity:
        return 'task_alt';
      case HabitCategory.hobbies:
        return 'palette';
      case HabitCategory.other:
        return 'interests';
    }
  }

  static HabitCategory? fromId(String? id) {
    if (id == null) return null;
    try {
      return HabitCategory.values.firstWhere((category) => category.id == id);
    } catch (_) {
      return null;
    }
  }
}
