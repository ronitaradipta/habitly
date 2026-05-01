import 'dart:convert';

import 'package:habitly/domain/entities/category.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/entities/habit_frequency.dart';
import 'package:habitly/domain/repositories/ai_chat_repository.dart';
import 'package:habitly/core/utils/habit_schedule_utils.dart';

/// Returns the tools JSON array for the Groq API request body.
List<Map<String, dynamic>> getToolsSchema() {
  return [
    _toolSchema(
      name: 'get_all_habits',
      description:
          "Get all of the user's habits with their details including name, category, frequency, and reminder settings",
      properties: {},
      required: [],
    ),
    _toolSchema(
      name: 'get_habit_completion_stats',
      description:
          'Get completion statistics for each habit over a specified number of days',
      properties: {
        'days': {
          'type': 'number',
          'description': 'Number of days to look back for stats (default 7)',
        },
      },
      required: [],
    ),
    _toolSchema(
      name: 'get_today_summary',
      description:
          "Get today's scheduled habits and their completion status",
      properties: {},
      required: [],
    ),
    _toolSchema(
      name: 'get_streaks',
      description: 'Get current and best streaks for each habit and overall',
      properties: {},
      required: [],
    ),
    _toolSchema(
      name: 'get_habits_by_category',
      description:
          'Get habits filtered by category with their completion rates',
      properties: {
        'category': {
          'type': 'string',
          'description':
              'Category name (health, fitness, career, finance, learning, relationships, productivity, hobbies, other)',
        },
      },
      required: ['category'],
    ),
    _toolSchema(
      name: 'create_habit',
      description:
          'Create a new habit for the user. Use when the user wants to start a new habit or asks you to create one.',
      properties: {
        'name': {
          'type': 'string',
          'description': 'Clear, specific habit name',
        },
        'categoryId': {
          'type': 'string',
          'description':
              'Category: health, fitness, career, finance, learning, relationships, productivity, hobbies, other',
        },
        'frequency': {
          'type': 'string',
          'description':
              'Frequency: daily, weekly, or monthly (default: daily)',
        },
        'reminderTime': {
          'type': 'string',
          'description': 'Optional reminder time in HH:mm 24-hour format',
        },
      },
      required: ['name', 'categoryId'],
    ),
  ];
}

Map<String, dynamic> _toolSchema({
  required String name,
  required String description,
  required Map<String, dynamic> properties,
  required List<String> required,
}) {
  return {
    'type': 'function',
    'function': {
      'name': name,
      'description': description,
      'parameters': {
        'type': 'object',
        'properties': properties,
        'required': required,
      },
    },
  };
}

/// Executes tool calls parsed from the API response.
///
/// Returns a list of tool result maps, each containing:
/// - `tool_call_id`: the id from the original tool call
/// - `name`: the function name
/// - `content`: JSON-encoded result string
Future<List<Map<String, dynamic>>> executeToolCalls(
  List<Map<String, dynamic>> toolCalls,
  List<Habit> habits, {
  CreateHabitCallback? onCreateHabit,
}) async {
  final results = <Map<String, dynamic>>[];
  for (final call in toolCalls) {
    final id = call['id'] as String? ?? '';
    final function_ = call['function'] as Map<String, dynamic>? ?? {};
    final name = function_['name'] as String? ?? '';
    if (name.isEmpty) continue;

    final args = function_['arguments'];
    Map<String, dynamic> parsedArgs;
    if (args is String && args.isNotEmpty) {
      parsedArgs = (jsonDecode(args) as Map<String, dynamic>?) ?? {};
    } else if (args is Map<String, dynamic>) {
      parsedArgs = args;
    } else {
      parsedArgs = {};
    }

    final result = await _executeTool(
      name,
      parsedArgs,
      habits,
      onCreateHabit: onCreateHabit,
    );
    results.add({
      'tool_call_id': id,
      'name': name,
      'content': jsonEncode(result),
    });
  }
  return results;
}

Future<dynamic> _executeTool(
  String name,
  Map<String, dynamic> args,
  List<Habit> habits, {
  CreateHabitCallback? onCreateHabit,
}) async {
  switch (name) {
    case 'get_all_habits':
      return _getAllHabits(habits);
    case 'get_habit_completion_stats':
      final days = (args['days'] as num?)?.toInt() ?? 7;
      return _getHabitCompletionStats(habits, days);
    case 'get_today_summary':
      return _getTodaySummary(habits);
    case 'get_streaks':
      return _getStreaks(habits);
    case 'get_habits_by_category':
      final category = args['category'] as String;
      return _getHabitsByCategory(habits, category);
    case 'create_habit':
      return _createHabit(args, onCreateHabit);
    default:
      return {'error': 'Unknown tool: $name'};
  }
}

// --- Tool implementations ---

Map<String, dynamic> _getAllHabits(List<Habit> habits) {
  if (habits.isEmpty) return {'habits': [], 'total': 0};

  return {
    'total': habits.length,
    'habits': habits
        .map((h) => {
              'name': h.name,
              'category': h.category?.displayName ?? 'General',
              'frequency': h.frequency.displayName,
              'has_reminder': h.hasReminder,
              'reminder_time': h.hasReminder ? h.formattedReminderTime : null,
            })
        .toList(),
  };
}

Map<String, dynamic> _getHabitCompletionStats(List<Habit> habits, int days) {
  if (habits.isEmpty) return {'habits': [], 'period_days': days};

  final today = DateTime.now();
  final start = today.subtract(Duration(days: days - 1));
  final stats = <Map<String, dynamic>>[];

  for (final habit in habits) {
    var scheduled = 0;
    var completed = 0;
    for (var i = 0; i < days; i++) {
      final date = start.add(Duration(days: i));
      if (!isHabitScheduledOnDate(habit, date)) continue;
      scheduled++;
      if (habit.isCompletedForDate(date)) completed++;
    }
    final rate = scheduled > 0 ? ((completed / scheduled) * 100).round() : 0;
    stats.add({
      'name': habit.name,
      'scheduled': scheduled,
      'completed': completed,
      'completion_rate': '$rate%',
    });
  }

  return {'period_days': days, 'habits': stats};
}

Map<String, dynamic> _getTodaySummary(List<Habit> habits) {
  final today = DateTime.now();
  final scheduled = <Map<String, dynamic>>[];

  for (final habit in habits) {
    if (!isHabitScheduledOnDate(habit, today)) continue;
    scheduled.add({
      'name': habit.name,
      'category': habit.category?.displayName ?? 'General',
      'completed': habit.isCompletedForDate(today),
    });
  }

  final completedCount = scheduled.where((h) => h['completed'] == true).length;
  return {
    'date': Habit.dateKey(today),
    'total_scheduled': scheduled.length,
    'total_completed': completedCount,
    'habits': scheduled,
  };
}

Map<String, dynamic> _getStreaks(List<Habit> habits) {
  if (habits.isEmpty) return {'habits': [], 'overall_current_streak': 0};

  final today = DateTime.now();
  final habitStreaks = <Map<String, dynamic>>[];

  for (final habit in habits) {
    var currentStreak = 0;
    var bestStreak = 0;
    var tempStreak = 0;

    for (var i = 0; i < 365; i++) {
      final date = today.subtract(Duration(days: i));
      if (!isHabitScheduledOnDate(habit, date)) continue;

      if (habit.isCompletedForDate(date)) {
        tempStreak++;
        if (i == 0 || currentStreak > 0) currentStreak = tempStreak;
        if (tempStreak > bestStreak) bestStreak = tempStreak;
      } else {
        if (i == 0) currentStreak = 0;
        tempStreak = 0;
      }
    }

    habitStreaks.add({
      'name': habit.name,
      'current_streak': currentStreak,
      'best_streak': bestStreak,
    });
  }

  final overallCurrent = habitStreaks.isEmpty
      ? 0
      : habitStreaks
          .map((h) => h['current_streak'] as int)
          .reduce((a, b) => a < b ? a : b);

  return {
    'overall_current_streak': overallCurrent,
    'habits': habitStreaks,
  };
}

Map<String, dynamic> _getHabitsByCategory(List<Habit> habits, String category) {
  final categoryLower = category.toLowerCase();
  final filtered = habits.where(
    (h) =>
        (h.category?.displayName ?? 'General').toLowerCase() == categoryLower,
  );

  if (filtered.isEmpty) {
    return {'category': category, 'habits': [], 'total': 0};
  }

  final today = DateTime.now();
  final start = today.subtract(const Duration(days: 6));
  final habitData = <Map<String, dynamic>>[];

  for (final habit in filtered) {
    var scheduled = 0;
    var completed = 0;
    for (var i = 0; i < 7; i++) {
      final date = start.add(Duration(days: i));
      if (!isHabitScheduledOnDate(habit, date)) continue;
      scheduled++;
      if (habit.isCompletedForDate(date)) completed++;
    }
    final rate = scheduled > 0 ? ((completed / scheduled) * 100).round() : 0;
    habitData.add({
      'name': habit.name,
      'frequency': habit.frequency.displayName,
      'completion_rate_7d': '$rate%',
    });
  }

  return {
    'category': category,
    'total': habitData.length,
    'habits': habitData,
  };
}

Future<Map<String, dynamic>> _createHabit(
  Map<String, dynamic> args,
  CreateHabitCallback? onCreateHabit,
) async {
  if (onCreateHabit == null) {
    return {'error': 'Habit creation is not available'};
  }

  final name = args['name'] as String?;
  if (name == null || name.isEmpty) {
    return {'error': 'Habit name is required'};
  }

  final categoryId = args['categoryId'] as String? ?? 'other';
  final frequencyStr = args['frequency'] as String? ?? 'daily';
  final reminderTime = args['reminderTime'] as String?;

  final category = HabitCategory.fromId(categoryId);
  final iconName = category?.iconName ?? 'check_circle';
  final frequency = HabitFrequency.fromName(frequencyStr);

  try {
    await onCreateHabit(
      name: name,
      iconName: iconName,
      targetDate: DateTime.now(),
      categoryId: categoryId,
      frequency: frequency,
      hasReminder: reminderTime != null,
      reminderTime: reminderTime,
    );
    return {
      'success': true,
      'habit_created': {
        'name': name,
        'category': category?.displayName ?? 'Other',
        'frequency': frequency.displayName,
        'reminder': reminderTime,
      },
    };
  } catch (e) {
    return {'error': 'Failed to create habit: $e'};
  }
}
