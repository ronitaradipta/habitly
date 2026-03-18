import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/domain/entities/chat_message.dart';
import 'package:habitly/domain/entities/habit.dart';
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

class AiChatNotifier extends Notifier<AiChatState> {
  SendChatMessageUseCase get _useCase =>
      ref.read(sendChatMessageUseCaseProvider);

  @override
  AiChatState build() => const AiChatState();

  Future<void> sendMessage(String text) async {
    final userMessage = ChatMessage(
      role: 'user',
      content: text,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
    );

    final habits = ref.read(habitProvider).value ?? <Habit>[];

    final response = await _useCase(
      message: text,
      history: state.messages,
      habits: habits,
    );

    final assistantMessage = ChatMessage(
      role: 'assistant',
      content: response,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, assistantMessage],
      isLoading: false,
    );
  }

  void resetChat() {
    state = const AiChatState();
  }
}

final aiChatProvider = NotifierProvider<AiChatNotifier, AiChatState>(
  AiChatNotifier.new,
);
