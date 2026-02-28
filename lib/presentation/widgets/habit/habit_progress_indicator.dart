import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/core/theme/text_style.dart';
import 'package:habitly/presentation/providers/progress_provider.dart';
import 'package:sizer/sizer.dart';

class HabitProgressIndicator extends ConsumerWidget {
  const HabitProgressIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final progress = ref.watch(progressProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors.textSecondary.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${progress.percentage}% completed',
                style: AppTextStyles.heading(
                  context,
                ).copyWith(fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
              if (progress.totalCount > 0)
                Text(
                  '${progress.completedCount}/${progress.totalCount}',
                  style: AppTextStyles.caption(
                    context,
                  ).copyWith(color: colors.textSecondary),
                ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.totalCount > 0
                  ? progress.completedCount / progress.totalCount
                  : 0,
              backgroundColor: colors.textSecondary.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            progress.motivationalMessage,
            style: AppTextStyles.caption(
              context,
            ).copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}
