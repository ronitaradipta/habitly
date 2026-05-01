import 'package:flutter/foundation.dart';
import 'package:habitly/core/services/ai_chat_tools.dart';
import 'package:habitly/core/services/groq_api_client.dart';
import 'package:habitly/domain/entities/chat_message.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/repositories/ai_chat_repository.dart';

class AiChatService {
  final GroqApiClient _client;

  AiChatService({required GroqApiClient client}) : _client = client;

  Future<String> sendMessage({
    required String message,
    required List<ChatMessage> history,
    required List<Habit> habits,
    CreateHabitCallback? onCreateHabit,
    void Function(String)? onToolStatus,
  }) async {
    if (!_client.hasApiKey) {
      return 'AI Chat is not available. Please set up your GROQ_API_KEY.';
    }

    try {
      // tool-calling request
      final stage1Messages = <Map<String, dynamic>>[
        {'role': 'system', 'content': _buildSystemPrompt()},
        for (final msg in history) {'role': msg.role, 'content': msg.content},
        {'role': 'user', 'content': message},
      ];

      final chat1Response = await _client.chatCompletion(
        messages: stage1Messages,
        tools: getToolsSchema(),
      );

      final choices = chat1Response['choices'] as List<dynamic>?;
      if (choices == null || choices.isEmpty) {
        return 'Sorry, I encountered an error. Please try again.';
      }
      final firstChoice = choices.first as Map<String, dynamic>;
      final responseMessage = firstChoice['message'] as Map<String, dynamic>?;
      if (responseMessage == null) {
        return 'Sorry, I encountered an error. Please try again.';
      }
      final toolCalls = responseMessage['tool_calls'] as List<dynamic>?;

      // If no tool calls, return the direct response
      if (toolCalls == null || toolCalls.isEmpty) {
        return (responseMessage['content'] as String?) ?? '';
      }

      // Execute tool calls and collect individual results
      final toolCallMaps = toolCalls
          .map((tc) => tc as Map<String, dynamic>)
          .toList();

      // Notify UI about which tools are being called
      for (final call in toolCallMaps) {
        final fn = call['function'] as Map<String, dynamic>? ?? {};
        final name = fn['name'] as String? ?? '';
        if (name.isNotEmpty) {
          onToolStatus?.call(_toolDisplayName(name));
          await Future.delayed(const Duration(milliseconds: 800));
        }
      }

      final toolResults = await executeToolCalls(
        toolCallMaps,
        habits,
        onCreateHabit: onCreateHabit,
      );

      // Format tool results as readable context for the system prompt.
      // We avoid using role: "tool" messages because this model does not
      // respect tool_choice: 'none' and will attempt further tool calls.
      final toolDataSummary = toolResults
          .map((r) => '[${r['name']}]: ${r['content']}')
          .join('\n');

      onToolStatus?.call('Generating response...');

      final stage2Messages = <Map<String, dynamic>>[
        {'role': 'system', 'content': _buildResponsePrompt(toolDataSummary)},
        for (final msg in history) {'role': msg.role, 'content': msg.content},
        {'role': 'user', 'content': message},
      ];

      final chat2Response = await _client.chatCompletion(
        messages: stage2Messages,
      );
      return GroqApiClient.extractContent(chat2Response);
    } catch (e) {
      debugPrint('AiChatService error: $e');
      return 'Sorry, I encountered an error. Please try again.';
    }
  }

  String _toolDisplayName(String toolName) {
    return switch (toolName) {
      'get_all_habits' => 'Fetching your habits...',
      'get_habit_completion_stats' => 'Checking completion stats...',
      'get_today_summary' => "Getting today's summary...",
      'get_streaks' => 'Checking your streaks...',
      'get_habits_by_category' => 'Filtering by category...',
      'create_habit' => 'Creating a new habit...',
      _ => 'Processing...',
    };
  }

  String _buildResponsePrompt(String toolData) {
    return '''You are a friendly, knowledgeable personal habit coach. Your name is Habitly Coach.

Here is the user's data you retrieved:
$toolData

INSTRUCTIONS:
- Be concise and encouraging in your responses
- Reference the user's specific habits and data in your response
- Provide actionable, practical advice
- Keep responses under 200 words unless the user asks for detail
- Use a warm, supportive tone
- If the user asks about habits they don't have, suggest adding them
- If you just created a habit, confirm what was created with details (name, category, frequency, reminder)
- If a habit creation failed, let the user know and suggest they try again''';
  }

  String _buildSystemPrompt() {
    return '''You are a friendly, knowledgeable personal habit coach. Your name is Habitly Coach.

You have access to tools that can retrieve the user's habit data and create new habits.

CRITICAL RULES:
- When the user wants to CREATE or ADD a new habit, you MUST call the create_habit tool. Do NOT just say you created it — actually call the tool.
- When the user asks about their habits, progress, or streaks, use the read tools (get_all_habits, get_streaks, etc.)
- For general advice that doesn't need user data, respond directly without tools.

INSTRUCTIONS:
- Be concise and encouraging in your responses
- Provide actionable, practical advice
- Keep responses under 200 words unless the user asks for detail
- Use a warm, supportive tone
- When creating a habit with create_habit, choose an appropriate category and frequency based on context
- You can call create_habit together with other tools in the same request''';
  }

}
