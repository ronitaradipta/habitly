import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:habitly/core/services/openrouter_api_client.dart';
import 'package:habitly/domain/entities/ai_insight.dart';
import 'package:habitly/domain/entities/analytics_range.dart';
import 'package:habitly/domain/entities/analytics_summary.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/core/utils/habit_schedule_utils.dart';

class AiInsightsService {
  final OpenRouterApiClient _client;

  AiInsightsService({required OpenRouterApiClient client}) : _client = client;

  static const _systemPrompt =
      '''You are a personal habit coach. Analyze the user's habit data and provide personal, specific, and actionable insights.
Return ONLY a JSON array of up to 5 insights:
[{"type": "positive|warning|tip", "text": "..."}]''';

  Future<List<AiInsight>> generateInsights({
    required List<Habit> habits,
    required AnalyticsRange range,
    required AnalyticsSummary summary,
  }) async {
    if (!_client.hasApiKey) {
      debugPrint('AiInsightsService: OPENROUTER_API_KEY is not available');
      return [];
    }
    try {
      final prompt = _buildPrompt(habits, range, summary);
      final response = await _client.chatCompletion(
        messages: [
          {'role': 'system', 'content': _systemPrompt},
          {'role': 'user', 'content': prompt},
        ],
        jsonMode: true,
      );
      final content = OpenRouterApiClient.extractContent(response);
      return _parseInsights(content);
    } catch (e) {
      debugPrint('AiInsightsService error: $e');
      return [];
    }
  }

  String _buildPrompt(
    List<Habit> habits,
    AnalyticsRange range,
    AnalyticsSummary summary,
  ) {
    final avgPercent = (summary.avgCompletionRate * 100).round();
    final rangeLabel = range.label;

    final rankedHabits = _computeRankedHabits(habits, range);
    final categoryBreakdown = _computeCategoryBreakdown(habits, range);
    final strugglingHabits = rankedHabits
        .where((h) => h['rate'] < 0.5)
        .toList();

    final rankedLines = rankedHabits
        .map(
          (h) =>
              '  - ${h['name']} (${h['category']}): '
              '${h['completed']}/${h['scheduled']} '
              '(${(h['rate'] * 100).round()}%)',
        )
        .join('\n');

    final categoryLines = categoryBreakdown.entries
        .map((e) {
          final completed = e.value['completed']!;
          final scheduled = e.value['scheduled']!;
          final rate = scheduled > 0 ? completed / scheduled : 0.0;
          return '  - ${e.key}: $completed/$scheduled (${(rate * 100).round()}%)';
        })
        .join('\n');

    final strugglingLines = strugglingHabits.isEmpty
        ? '  - None'
        : strugglingHabits
              .map((h) => '  - ${h['name']} (${(h['rate'] * 100).round()}%)')
              .join('\n');

    return '''
Analyze the following habit data for the $rangeLabel time range:

SUMMARY:
- Average completion rate: $avgPercent%
- Current streak: ${summary.currentStreak} consecutive perfect days
- Best streak: ${summary.bestStreak} days
- Perfect days: ${summary.perfectDays} days
- Total: ${summary.totalCompleted}/${summary.totalScheduled} completions

ALL HABITS (ranked by completion rate, high to low):
$rankedLines

PERFORMANCE BY CATEGORY:
$categoryLines

STRUGGLING HABITS (below 50%):
$strugglingLines

Provide up to 5 insights in the following JSON array format:
[{"type": "positive|warning|tip", "text": "..."}]

Type guide:
- "positive": good achievements or positive trends
- "warning": habits that need attention or declining trends
- "tip": actionable advice to improve performance

Make sure each insight is specific and references relevant habit names or numbers.
Reply with the JSON array only, no additional text.
''';
  }

  List<Map<String, dynamic>> _computeRankedHabits(
    List<Habit> habits,
    AnalyticsRange range,
  ) {
    final today = DateTime.now();
    final startDate = today.subtract(Duration(days: range.days - 1));
    final result = <Map<String, dynamic>>[];

    for (final habit in habits) {
      var scheduled = 0;
      var completed = 0;
      for (var i = 0; i < range.days; i++) {
        final date = startDate.add(Duration(days: i));
        if (!isHabitScheduledOnDate(habit, date)) continue;
        scheduled++;
        if (habit.isCompletedForDate(date)) completed++;
      }
      if (scheduled == 0) continue;
      final rate = completed / scheduled;
      result.add({
        'name': habit.name,
        'category': habit.category?.displayName ?? 'General',
        'rate': rate,
        'completed': completed,
        'scheduled': scheduled,
      });
    }

    result.sort((a, b) => (b['rate'] as double).compareTo(a['rate'] as double));
    return result;
  }

  Map<String, Map<String, int>> _computeCategoryBreakdown(
    List<Habit> habits,
    AnalyticsRange range,
  ) {
    final today = DateTime.now();
    final startDate = today.subtract(Duration(days: range.days - 1));
    final byCategory = <String, Map<String, int>>{};

    for (final habit in habits) {
      final cat = habit.category?.displayName ?? 'General';
      byCategory[cat] ??= {'completed': 0, 'scheduled': 0};

      for (var i = 0; i < range.days; i++) {
        final date = startDate.add(Duration(days: i));
        if (!isHabitScheduledOnDate(habit, date)) continue;
        byCategory[cat]!['scheduled'] = byCategory[cat]!['scheduled']! + 1;
        if (habit.isCompletedForDate(date)) {
          byCategory[cat]!['completed'] = byCategory[cat]!['completed']! + 1;
        }
      }
    }

    return byCategory;
  }

  List<AiInsight> _parseInsights(String text) {
    try {
      // Extract JSON array from the response (in case there's extra text)
      final start = text.indexOf('[');
      final end = text.lastIndexOf(']');
      if (start == -1 || end == -1 || end <= start) return [];
      final jsonText = text.substring(start, end + 1);
      final decoded = jsonDecode(jsonText);
      if (decoded is! List) return [];
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(AiInsight.fromJson)
          .where((insight) => insight.text.isNotEmpty)
          .take(5)
          .toList();
    } catch (_) {
      return [];
    }
  }
}
