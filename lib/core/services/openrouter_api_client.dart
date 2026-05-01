import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpenRouterApiClient {
  static const defaultModel = 'openai/gpt-oss-120b:free';
  static const _apiUrl = 'https://openrouter.ai/api/v1/chat/completions';

  final String _apiKey;

  OpenRouterApiClient() : _apiKey = dotenv.env['OPENROUTER_API_KEY'] ?? '';

  bool get hasApiKey => _apiKey.isNotEmpty;

  /// Sends a chat completion request to the OpenRouter API.
  Future<Map<String, dynamic>> chatCompletion({
    required List<Map<String, dynamic>> messages,
    List<Map<String, dynamic>>? tools,
    String? toolChoice,
    bool jsonMode = false,
    double temperature = 1.0,
    int maxTokens = 8192,
    String model = defaultModel,
  }) async {
    final body = <String, dynamic>{
      'model': model,
      'messages': messages,
      'temperature': temperature,
      'max_tokens': maxTokens,
    };
    if (tools != null && tools.isNotEmpty) {
      body['tools'] = tools;
    }
    if (toolChoice != null) {
      body['tool_choice'] = toolChoice;
    }
    if (jsonMode) {
      body['response_format'] = {'type': 'json_object'};
    }

    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 15);
    try {
      final request = await client.postUrl(Uri.parse(_apiUrl));
      request.headers.set('Authorization', 'Bearer $_apiKey');
      request.headers.set('X-Title', 'HabitLy');
      request.headers.set('Content-Type', 'application/json; charset=utf-8');
      request.add(utf8.encode(jsonEncode(body)));

      final response = await request.close().timeout(
        const Duration(seconds: 30),
      );
      final responseBody = await response
          .transform(utf8.decoder)
          .join()
          .timeout(const Duration(seconds: 30));

      // Guard against unexpectedly large responses (>2 MB)
      if (responseBody.length > 2 * 1024 * 1024) {
        throw Exception(
          'OpenRouter API response too large: ${responseBody.length} bytes',
        );
      }

      if (response.statusCode >= 300) {
        throw Exception(
          'OpenRouter API error (${response.statusCode}): $responseBody',
        );
      }

      return jsonDecode(responseBody) as Map<String, dynamic>;
    } finally {
      client.close();
    }
  }

  /// Extracts the text content from a chat completion response.
  static String extractContent(Map<String, dynamic> response) {
    final choices = response['choices'] as List<dynamic>?;
    if (choices == null || choices.isEmpty) return '';
    final message =
        (choices.first as Map<String, dynamic>)['message']
            as Map<String, dynamic>?;
    return (message?['content'] as String?) ?? '';
  }
}
