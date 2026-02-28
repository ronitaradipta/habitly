import 'package:habitly/domain/entities/category.dart';

class PresetHabit {
  final String id;
  final String name;
  final HabitCategory category;

  const PresetHabit({
    required this.id,
    required this.name,
    required this.category,
  });
}

final List<PresetHabit> presetHabits = [
  // Health
  PresetHabit(id: 'drink_water', name: 'Drink Water', category: HabitCategory.health),
  PresetHabit(id: 'sleep_early', name: 'Sleep Early', category: HabitCategory.health),
  PresetHabit(id: 'meditate', name: 'Meditate', category: HabitCategory.health),
  PresetHabit(id: 'take_vitamins', name: 'Take Vitamins', category: HabitCategory.health),

  // Fitness
  PresetHabit(id: 'workout', name: 'Workout', category: HabitCategory.fitness),
  PresetHabit(id: 'go_for_walk', name: 'Go for a Walk', category: HabitCategory.fitness),
  PresetHabit(id: 'stretch', name: 'Stretch', category: HabitCategory.fitness),
  PresetHabit(id: 'track_calories', name: 'Track Calories', category: HabitCategory.fitness),

  // Career
  PresetHabit(id: 'deep_work', name: 'Deep Work Session', category: HabitCategory.career),
  PresetHabit(id: 'update_resume', name: 'Update Resume', category: HabitCategory.career),
  PresetHabit(id: 'network', name: 'Network', category: HabitCategory.career),
  PresetHabit(id: 'learn_skill', name: 'Learn a Skill', category: HabitCategory.career),

  // Finance
  PresetHabit(id: 'track_expenses', name: 'Track Expenses', category: HabitCategory.finance),
  PresetHabit(id: 'no_impulse_buys', name: 'No Impulse Buys', category: HabitCategory.finance),
  PresetHabit(id: 'save_money', name: 'Save Money', category: HabitCategory.finance),
  PresetHabit(id: 'review_budget', name: 'Review Budget', category: HabitCategory.finance),

  // Learning
  PresetHabit(id: 'read_20_min', name: 'Read 20 Minutes', category: HabitCategory.learning),
  PresetHabit(id: 'practice_language', name: 'Practice Language', category: HabitCategory.learning),
  PresetHabit(id: 'watch_tutorial', name: 'Watch Tutorial', category: HabitCategory.learning),
  PresetHabit(id: 'take_notes', name: 'Take Notes', category: HabitCategory.learning),

  // Relationships
  PresetHabit(id: 'call_friend', name: 'Call a Friend', category: HabitCategory.relationships),
  PresetHabit(id: 'family_time', name: 'Family Time', category: HabitCategory.relationships),
  PresetHabit(id: 'write_thank_you', name: 'Write Thank You', category: HabitCategory.relationships),
  PresetHabit(id: 'plan_date', name: 'Plan a Date', category: HabitCategory.relationships),

  // Productivity
  PresetHabit(id: 'plan_tomorrow', name: 'Plan Tomorrow', category: HabitCategory.productivity),
  PresetHabit(id: 'inbox_zero', name: 'Inbox Zero', category: HabitCategory.productivity),
  PresetHabit(id: 'review_goals', name: 'Review Goals', category: HabitCategory.productivity),
  PresetHabit(id: 'declutter', name: 'Declutter 5 Min', category: HabitCategory.productivity),

  // Hobbies
  PresetHabit(id: 'practice_music', name: 'Practice Music', category: HabitCategory.hobbies),
  PresetHabit(id: 'draw_or_paint', name: 'Draw or Paint', category: HabitCategory.hobbies),
  PresetHabit(id: 'photography', name: 'Photography', category: HabitCategory.hobbies),
  PresetHabit(id: 'cook_new', name: 'Cook Something New', category: HabitCategory.hobbies),

  // Other
  PresetHabit(id: 'journaling', name: 'Journaling', category: HabitCategory.other),
  PresetHabit(id: 'digital_detox', name: 'Digital Detox Hour', category: HabitCategory.other),
  PresetHabit(id: 'practice_gratitude', name: 'Practice Gratitude', category: HabitCategory.other),
  PresetHabit(id: 'tidy_up', name: 'Tidy Up Space', category: HabitCategory.other),
];
