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
