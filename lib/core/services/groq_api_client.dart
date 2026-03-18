import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class GroqApiClient {
  static const defaultModel = 'openai/gpt-oss-120b';
  static const _apiUrl = 'https://api.groq.com/openai/v1/chat/completions';

  final FirebaseFirestore _firestore;
  String _apiKey = '';
  bool _initialized = false;

  GroqApiClient({required FirebaseFirestore firestore})
    : _firestore = firestore;

  bool get hasApiKey => _apiKey.isNotEmpty;

  Future<bool> ensureInitialized() async {
    if (_initialized) return hasApiKey;
    try {
      final doc = await _firestore
          .collection('app_config')
          .doc('api_keys')
          .get();
      _apiKey = (doc.data()?['groq_api_key'] as String?) ?? '';
      _initialized = true;
    } catch (e) {
      debugPrint('GroqApiClient: Failed to fetch API key from Firestore: $e');
    }
    return hasApiKey;
  }

  /// Sends a chat completion request to the Groq API.
  Future<Map<String, dynamic>> chatCompletion({
    required List<Map<String, dynamic>> messages,
    List<Map<String, dynamic>>? tools,
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
    if (jsonMode) {
      body['response_format'] = {'type': 'json_object'};
    }

    final client = HttpClient();
    try {
      final request = await client.postUrl(Uri.parse(_apiUrl));
      request.headers.set('Authorization', 'Bearer $_apiKey');
      request.headers.set('Content-Type', 'application/json; charset=utf-8');
      request.add(utf8.encode(jsonEncode(body)));

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode >= 300) {
        throw Exception(
          'Groq API error (${response.statusCode}): $responseBody',
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
