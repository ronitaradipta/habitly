import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/presentation/providers/ai_chat_provider.dart';
import 'package:habitly/presentation/utils/auth_listener.dart';
import 'package:habitly/presentation/widgets/chat/chat_message_bubble.dart';
import 'package:habitly/presentation/widgets/chat/chat_typing_indicator.dart';
import 'package:habitly/presentation/widgets/chat/chat_welcome_view.dart';
import 'package:habitly/presentation/widgets/shared/navigation/bottom_nav_bar.dart';
import 'package:habitly/presentation/widgets/shared/navigation/custom_app_bar.dart';
import 'package:habitly/presentation/widgets/shared/theme_scaffold.dart';

class AiChatPage extends ConsumerStatefulWidget {
  const AiChatPage({super.key});

  @override
  ConsumerState<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends ConsumerState<AiChatPage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  static const _suggestedQuestions = [
    'How am I doing?',
    'Tips for consistency',
    'Which habits should I focus on?',
    'How to build a morning routine?',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(aiChatProvider.notifier).resetChat();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    _controller.clear();
    ref.read(aiChatProvider.notifier).sendMessage(trimmed);

    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(aiChatProvider);
    final colors = AppColors.of(context);

    listenForAuthRedirect(ref, context);

    ref.listen(aiChatProvider, (previous, next) {
      if (previous != null &&
          previous.messages.length != next.messages.length) {
        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
      }
    });

    return ThemeScaffold(
      showThemeButton: false,
      body: Column(
        children: [
          const CustomAppBar(title: 'AI Coach'),

          // Messages
          Expanded(
            child: chatState.messages.isEmpty
                ? ChatWelcomeView(
                    suggestedQuestions: _suggestedQuestions,
                    onQuestionTap: _sendMessage,
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount:
                        chatState.messages.length +
                        (chatState.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == chatState.messages.length) {
                        return const ChatTypingIndicator();
                      }
                      final message = chatState.messages[index];
                      return ChatMessageBubble(message: message);
                    },
                  ),
          ),

          // Input
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            decoration: BoxDecoration(
              color: colors.surface,
              boxShadow: [
                BoxShadow(
                  color: colors.textSecondary.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: AppTextStyles.body(context),
                      decoration: InputDecoration(
                        hintText: 'Ask your habit coach...',
                        hintStyle: AppTextStyles.inputHint(context),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: colors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: colors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: colors.primary),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        isDense: true,
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: chatState.isLoading ? null : _sendMessage,
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    onPressed: chatState.isLoading
                        ? null
                        : () => _sendMessage(_controller.text),
                    icon: Icon(
                      Icons.send_rounded,
                      color: chatState.isLoading
                          ? colors.disabled
                          : colors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const BottomNavBar(currentItem: BottomNavItem.aiChat),
        ],
      ),
    );
  }
}
