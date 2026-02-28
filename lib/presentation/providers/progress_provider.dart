import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/presentation/providers/filtered_habits_provider.dart';
import 'package:habitly/presentation/providers/selected_category_provider.dart';

class ProgressData {
  final int completedCount;
  final int totalCount;
  final int percentage;
  final String motivationalMessage;

  const ProgressData({
    required this.completedCount,
    required this.totalCount,
    required this.percentage,
    required this.motivationalMessage,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgressData &&
          runtimeType == other.runtimeType &&
          completedCount == other.completedCount &&
          totalCount == other.totalCount &&
          percentage == other.percentage &&
          motivationalMessage == other.motivationalMessage;

  @override
  int get hashCode =>
      completedCount.hashCode ^
      totalCount.hashCode ^
      percentage.hashCode ^
      motivationalMessage.hashCode;
}

String _getMotivationalMessage(int percentage) {
  if (percentage == 0) {
    return 'Start your journey!';
  } else if (percentage < 50) {
    return 'Keep going, you\'re doing great!';
  } else if (percentage < 100) {
    return 'Almost there, stay strong!';
  } else {
    return 'Perfect! All habits completed! 🎉';
  }
}

final progressProvider = Provider<ProgressData>((ref) {
  final dateFiltered = ref.watch(dateFilteredHabitsProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);

  final habitsAsync = dateFiltered.whenData((habits) {
    if (selectedCategory == null) return habits;
    return habits.where((h) => h.category == selectedCategory).toList();
  });

  return habitsAsync.when(
    loading: () => const ProgressData(
      completedCount: 0,
      totalCount: 0,
      percentage: 0,
      motivationalMessage: 'Loading...',
    ),
    error: (_, _) => const ProgressData(
      completedCount: 0,
      totalCount: 0,
      percentage: 0,
      motivationalMessage: 'Error loading habits',
    ),
    data: (habits) {
      final completedCount = habits.where((h) => h.isCompleted).length;
      final totalCount = habits.length;
      final percentage =
          totalCount > 0 ? (completedCount / totalCount * 100).round() : 0;

      final message = _getMotivationalMessage(percentage);

      return ProgressData(
        completedCount: completedCount,
        totalCount: totalCount,
        percentage: percentage,
        motivationalMessage: message,
      );
    },
  );
});
