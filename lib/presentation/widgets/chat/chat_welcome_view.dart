import 'package:flutter/material.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';

class ChatWelcomeView extends StatelessWidget {
  final List<String> suggestedQuestions;
  final ValueChanged<String> onQuestionTap;

  const ChatWelcomeView({
    super.key,
    required this.suggestedQuestions,
    required this.onQuestionTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_awesome, size: 48, color: colors.primary),
          const SizedBox(height: 16),
          Text(
            "Hi! I'm your AI habit coach.",
            style: AppTextStyles.headingSmall(context),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Ask me anything about your habits!',
            style: AppTextStyles.caption(context),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: suggestedQuestions
                .map(
                  (q) => ActionChip(
                    label: Text(
                      q,
                      style: AppTextStyles.captionSmall(
                        context,
                      ).copyWith(color: colors.primary),
                    ),
                    backgroundColor: colors.primary.withValues(alpha: 0.1),
                    side: BorderSide(
                      color: colors.primary.withValues(alpha: 0.3),
                    ),
                    onPressed: () => onQuestionTap(q),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
