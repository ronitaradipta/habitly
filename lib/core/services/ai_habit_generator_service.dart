import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:habitly/core/services/groq_api_client.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/entities/suggested_habit.dart';

class AiHabitGeneratorService {
  final GroqApiClient _client;

  AiHabitGeneratorService({required GroqApiClient client}) : _client = client;

  static const _systemPrompt = '''You are a habit design expert. Given user goals, suggest 5-8 specific, actionable habits they should build.
Always respond in English.
Return ONLY a JSON array of habits with these exact fields:
[{"name": "...", "categoryId": "...", "frequency": "...", "reminderTime": "HH:mm or null", "reason": "..."}]

Valid categoryId values: health, fitness, career, finance, learning, relationships, productivity, hobbies, other

Valid frequency values: daily, weekly, monthly''';

  Future<List<SuggestedHabit>> generateHabits({
    required String userGoals,
    required List<Habit> existingHabits,
  }) async {
    if (!_client.hasApiKey) {
      debugPrint('AiHabitGeneratorService: GROQ_API_KEY is not available');
      return [];
    }

    try {
      final prompt = _buildPrompt(userGoals, existingHabits);
      final response = await _client.chatCompletion(
        messages: [
          {'role': 'system', 'content': _systemPrompt},
          {'role': 'user', 'content': prompt},
        ],
        jsonMode: true,
      );
      final content = GroqApiClient.extractContent(response);
      return _parseHabits(content);
    } catch (e) {
      debugPrint('AiHabitGeneratorService error: $e');
      return [];
    }
  }

  String _buildPrompt(String userGoals, List<Habit> existingHabits) {
    final existingNames = existingHabits.map((h) => h.name).join(', ');
    final existingSection = existingHabits.isEmpty
        ? ''
        : '\n\nEXISTING HABITS (avoid duplicates): $existingNames';

    return '''USER'S GOALS: $userGoals$existingSection

Suggest 5-8 specific, actionable habits that will help achieve these goals.
Each habit should be concrete (e.g., "Drink 8 glasses of water" not just "Stay hydrated").
Reply with the JSON array only, no additional text.''';
  }

  List<SuggestedHabit> _parseHabits(String text) {
    try {
      final start = text.indexOf('[');
      final end = text.lastIndexOf(']');
      if (start == -1 || end == -1 || end <= start) return [];
      final jsonText = text.substring(start, end + 1);
      final decoded = jsonDecode(jsonText);
      if (decoded is! List) return [];
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(SuggestedHabit.fromJson)
          .where((h) => h.name.isNotEmpty)
          .take(8)
          .toList();
    } catch (_) {
      return [];
    }
  }
}
