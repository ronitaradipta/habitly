import 'package:flutter/foundation.dart';
import 'package:habitly/core/services/ai_chat_tools.dart';
import 'package:habitly/core/services/groq_api_client.dart';
import 'package:habitly/domain/entities/chat_message.dart';
import 'package:habitly/domain/entities/habit.dart';

class AiChatService {
  final GroqApiClient _client;

  AiChatService({required GroqApiClient client}) : _client = client;

  Future<String> sendMessage({
    required String message,
    required List<ChatMessage> history,
    required List<Habit> habits,
  }) async {
    if (!await _client.ensureInitialized()) {
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

      // Execute tool calls and collect results
      final toolCallMaps = toolCalls
          .map((tc) => tc as Map<String, dynamic>)
          .toList();
      final toolResults = executeToolCalls(toolCallMaps, habits);

      // final response with tool data injected as context
      final stage2Messages = <Map<String, dynamic>>[
        {'role': 'system', 'content': _buildSystemPromptWithData(toolResults)},
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

  String _buildSystemPrompt() {
    return '''You are a friendly, knowledgeable personal habit coach. Your name is Habitly Coach.

You have access to tools that can retrieve the user's habit data. Use them when the user asks about their habits, progress, streaks, or anything that requires their actual data.

For general questions about habit building, motivation, or advice that don't require the user's specific data, respond directly without using tools.

INSTRUCTIONS:
- Be concise and encouraging in your responses
- Provide actionable, practical advice
- Keep responses under 200 words unless the user asks for detail
- Use a warm, supportive tone
- If the user asks about habits they don't have, suggest adding them''';
  }

  String _buildSystemPromptWithData(String toolResults) {
    return '''You are a friendly, knowledgeable personal habit coach. Your name is Habitly Coach.

Here is the user's habit data you retrieved:
$toolResults

INSTRUCTIONS:
- Be concise and encouraging in your responses
- Reference the user's specific habits and data in your response
- Provide actionable, practical advice
- Keep responses under 200 words unless the user asks for detail
- Use a warm, supportive tone
- If the user asks about habits they don't have, suggest adding them''';
  }
}
