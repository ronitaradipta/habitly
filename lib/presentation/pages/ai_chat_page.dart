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
    'Create a morning meditation habit',
  ];

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

  Future<void> _showClearHistoryDialog() async {
    final colors = AppColors.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('New Chat', style: AppTextStyles.headingSmall(context)),
        content: Text(
          'This will clear your entire chat history. Are you sure?',
          style: AppTextStyles.body(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: AppTextStyles.body(context).copyWith(
                color: colors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Clear',
              style: AppTextStyles.body(context).copyWith(
                color: colors.error,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(aiChatProvider.notifier).clearHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(aiChatProvider);
    final colors = AppColors.of(context);

    listenForAuthRedirect(ref, context);

    ref.listen(aiChatProvider, (previous, next) {
      final prevMessages = previous?.asData?.value.messages ?? [];
      final nextMessages = next.asData?.value.messages ?? [];
      if (prevMessages.length != nextMessages.length) {
        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
      }
    });

    return ThemeScaffold(
      showThemeButton: false,
      body: Column(
        children: [
          CustomAppBar(
            title: 'AI Coach',
            trailing: [
              IconButton(
                onPressed: _showClearHistoryDialog,
                icon: Icon(
                  Icons.add_comment_outlined,
                  color: colors.textSecondary,
                ),
                tooltip: 'New Chat',
              ),
            ],
          ),

          // Messages
          Expanded(
            child: asyncState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Text(
                  'Failed to load chat history',
                  style: AppTextStyles.body(context),
                ),
              ),
              data: (chatState) {
                if (chatState.messages.isEmpty) {
                  return ChatWelcomeView(
                    suggestedQuestions: _suggestedQuestions,
                    onQuestionTap: _sendMessage,
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: chatState.messages.length +
                      (chatState.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == chatState.messages.length) {
                      return const ChatTypingIndicator();
                    }
                    final message = chatState.messages[index];
                    return ChatMessageBubble(message: message);
                  },
                );
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
                      onSubmitted: (asyncState.asData?.value.isLoading ?? false)
                          ? null
                          : _sendMessage,
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    onPressed: (asyncState.asData?.value.isLoading ?? false)
                        ? null
                        : () => _sendMessage(_controller.text),
                    icon: Icon(
                      Icons.send_rounded,
                      color: (asyncState.asData?.value.isLoading ?? false)
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
