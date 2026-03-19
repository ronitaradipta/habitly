import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/constants/app_constants.dart';
import 'package:habitly/domain/entities/chat_message.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:habitly/domain/usecases/clear_chat_history_use_case.dart';
import 'package:habitly/domain/usecases/get_chat_history_use_case.dart';
import 'package:habitly/domain/usecases/save_chat_message_use_case.dart';
import 'package:habitly/domain/usecases/send_chat_message_use_case.dart';
import 'package:habitly/presentation/providers/habit_provider.dart';
import 'package:habitly/presentation/providers/use_case_providers.dart';

class AiChatState {
  final List<ChatMessage> messages;
  final bool isLoading;

  const AiChatState({
    this.messages = const [],
    this.isLoading = false,
  });

  AiChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
  }) =>
      AiChatState(
        messages: messages ?? this.messages,
        isLoading: isLoading ?? this.isLoading,
      );
}

class AiChatNotifier extends AsyncNotifier<AiChatState> {
  SendChatMessageUseCase get _sendUseCase =>
      ref.read(sendChatMessageUseCaseProvider);
  GetChatHistoryUseCase get _getHistoryUseCase =>
      ref.read(getChatHistoryUseCaseProvider);
  SaveChatMessageUseCase get _saveMessageUseCase =>
      ref.read(saveChatMessageUseCaseProvider);
  ClearChatHistoryUseCase get _clearHistoryUseCase =>
      ref.read(clearChatHistoryUseCaseProvider);

  @override
  Future<AiChatState> build() async {
    final messages = await _getHistoryUseCase();
    return AiChatState(messages: messages);
  }

  Future<void> sendMessage(String text) async {
    final currentState = state.asData?.value ?? const AiChatState();

    final userMessage = ChatMessage(
      role: 'user',
      content: text,
      timestamp: DateTime.now(),
    );

    state = AsyncData(
      currentState.copyWith(
        messages: [...currentState.messages, userMessage],
        isLoading: true,
      ),
    );

    // Save user message to Firestore
    _saveMessageUseCase(userMessage).catchError((e) {
      debugPrint('Failed to save user message: $e');
    });

    try {
      final habits = ref.read(habitProvider).value ?? <Habit>[];
      final updatedState = state.asData!.value;

      final response = await _sendUseCase(
        message: text,
        history: updatedState.messages,
        habits: habits,
      );

      final assistantMessage = ChatMessage(
        role: 'assistant',
        content: response,
        timestamp: DateTime.now(),
      );

      state = AsyncData(
        updatedState.copyWith(
          messages: [...updatedState.messages, assistantMessage],
          isLoading: false,
        ),
      );

      // Save assistant message to Firestore
      _saveMessageUseCase(assistantMessage).catchError((e) {
        debugPrint('Failed to save assistant message: $e');
      });

      // Refresh habit list in case a habit was created via chat
      ref.invalidate(habitProvider);
    } catch (e) {
      debugPrint('AiChatNotifier.sendMessage failed: $e');
      final errorText = e is TimeoutException
          ? AppErrorMessages.timeout
          : AppErrorMessages.genericError;
      final errorMessage = ChatMessage(
        role: 'assistant',
        content: errorText,
        timestamp: DateTime.now(),
      );

      final current = state.asData!.value;
      state = AsyncData(
        current.copyWith(
          messages: [...current.messages, errorMessage],
          isLoading: false,
        ),
      );

      // Save error message to Firestore too
      _saveMessageUseCase(errorMessage).catchError((e) {
        debugPrint('Failed to save error message: $e');
      });
    }
  }

  Future<void> clearHistory() async {
    await _clearHistoryUseCase();
    state = const AsyncData(AiChatState());
  }
}

final aiChatProvider = AsyncNotifierProvider<AiChatNotifier, AiChatState>(
  AiChatNotifier.new,
);
