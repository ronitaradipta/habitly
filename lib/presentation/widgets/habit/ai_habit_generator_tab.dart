import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/presentation/providers/ai_habit_generator_provider.dart';
import 'package:habitly/presentation/utils/snackbar_utils.dart';
import 'package:habitly/presentation/widgets/habit/suggestion_card.dart';

class AiHabitGeneratorTab extends ConsumerStatefulWidget {
  const AiHabitGeneratorTab({super.key});

  @override
  ConsumerState<AiHabitGeneratorTab> createState() =>
      _AiHabitGeneratorTabState();
}

class _AiHabitGeneratorTabState extends ConsumerState<AiHabitGeneratorTab> {
  final _goalsController = TextEditingController();

  @override
  void dispose() {
    _goalsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final genState = ref.watch(aiHabitGeneratorProvider);

    ref.listen<AiHabitGeneratorState>(aiHabitGeneratorProvider, (previous, next) {
      if (next.addedCount != null && next.addedCount != previous?.addedCount) {
        AppSnackBar.showSuccess(context, '${next.addedCount} habit(s) added!');
        SchedulerBinding.instance.addPostFrameCallback((_) {
          ref.read(aiHabitGeneratorProvider.notifier).reset();
          if (context.mounted) Navigator.pop(context);
        });
      }
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          Text(
            'Describe your goals',
            style: AppTextStyles.bodyBold(context),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _goalsController,
            style: AppTextStyles.body(context),
            maxLines: 3,
            decoration: InputDecoration(
              hintText:
                  'e.g., I want to be healthier, more productive, and learn new skills',
              hintStyle: AppTextStyles.inputHint(context),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colors.primary),
              ),
              contentPadding: const EdgeInsets.all(14),
            ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: genState.isLoading
                  ? null
                  : () {
                      final goals = _goalsController.text.trim();
                      if (goals.isEmpty) {
                        AppSnackBar.show(
                          context,
                          'Please describe your goals first',
                        );
                        return;
                      }
                      ref
                          .read(aiHabitGeneratorProvider.notifier)
                          .generate(goals);
                    },
              icon: genState.isLoading
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.surface,
                      ),
                    )
                  : const Icon(Icons.auto_awesome),
              label: Text(
                genState.isLoading ? 'Generating...' : 'Generate Habits',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.surface,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          if (genState.error != null) ...[
            const SizedBox(height: 12),
            Text(
              genState.error!,
              style: AppTextStyles.caption(context)
                  .copyWith(color: colors.error),
            ),
          ],

          if (genState.suggestions.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              'Suggested Habits',
              style: AppTextStyles.bodyBold(context),
            ),
            const SizedBox(height: 4),
            Text(
              'Select the habits you want to add',
              style: AppTextStyles.captionSmall(context),
            ),
            const SizedBox(height: 12),

            ...List.generate(genState.suggestions.length, (index) {
              final suggestion = genState.suggestions[index];
              final isSelected = genState.selectedIndices.contains(index);
              return SuggestionCard(
                suggestion: suggestion,
                isSelected: isSelected,
                onTap: genState.isAdding
                    ? null
                    : () => ref
                        .read(aiHabitGeneratorProvider.notifier)
                        .toggleSelection(index),
              );
            }),

            if (genState.selectedIndices.isNotEmpty) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: genState.isAdding
                      ? null
                      : () => ref
                          .read(aiHabitGeneratorProvider.notifier)
                          .addSelectedHabits(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.surface,
                    disabledBackgroundColor: colors.primary.withValues(alpha: 0.6),
                    disabledForegroundColor: colors.surface,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: genState.isAdding
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colors.surface,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('Adding...'),
                          ],
                        )
                      : Text(
                          'Add ${genState.selectedIndices.length} Selected Habit(s)',
                        ),
                ),
              ),
            ],

            const SizedBox(height: 32),
          ],
        ],
      ),
    );
  }
}
