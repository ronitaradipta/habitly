import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/constants/routes.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/presentation/providers/ai_habit_generator_provider.dart';
import 'package:habitly/presentation/widgets/habit/suggestion_card.dart';
import 'package:habitly/presentation/widgets/shared/onboarding/onboarding_button_row.dart';
import 'package:habitly/presentation/widgets/shared/onboarding/onboarding_progress_bar.dart';
import 'package:habitly/presentation/widgets/shared/theme_scaffold.dart';
import 'package:sizer/sizer.dart';

class AiOnboardingPage extends ConsumerStatefulWidget {
  const AiOnboardingPage({super.key});

  @override
  ConsumerState<AiOnboardingPage> createState() => _AiOnboardingPageState();
}

class _AiOnboardingPageState extends ConsumerState<AiOnboardingPage> {
  final _goalsController = TextEditingController();

  @override
  void dispose() {
    _goalsController.dispose();
    super.dispose();
  }

  void _navigateToReminder() {
    ref.read(aiHabitGeneratorProvider.notifier).reset();
    Navigator.pushReplacementNamed(context, AppRoutes.reminderTime);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final genState = ref.watch(aiHabitGeneratorProvider);

    ref.listen<AiHabitGeneratorState>(aiHabitGeneratorProvider, (prev, next) {
      if (next.addedCount != null && next.addedCount != prev?.addedCount) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${next.addedCount} habit(s) added!')),
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _navigateToReminder();
        });
      }
    });

    return ThemeScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const OnboardingProgressBar(value: 0.5),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Let AI build your habits",
                    style: AppTextStyles.heading(context)
                        .copyWith(fontSize: 18.sp),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Describe your goals and we'll suggest habits for you",
                    style: AppTextStyles.caption(context),
                  ),
                  const SizedBox(height: 20),

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
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Please describe your goals first'),
                                  ),
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
                      final isSelected =
                          genState.selectedIndices.contains(index);
                      return SuggestionCard(
                        suggestion: suggestion,
                        isSelected: isSelected,
                        onTap: () => ref
                            .read(aiHabitGeneratorProvider.notifier)
                            .toggleSelection(index),
                      );
                    }),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ),
          OnboardingButtonRow(
            onSkip: _navigateToReminder,
            isLoading: genState.isAdding,
            onProceed: genState.selectedIndices.isNotEmpty
                ? () => ref
                    .read(aiHabitGeneratorProvider.notifier)
                    .addSelectedHabits()
                : null,
          ),
        ],
      ),
    );
  }
}
