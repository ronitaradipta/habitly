enum InsightType { positive, warning, tip }

class AiInsight {
  final InsightType type;
  final String text;

  const AiInsight({required this.type, required this.text});

  factory AiInsight.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String? ?? 'tip';
    final type = switch (typeStr) {
      'positive' => InsightType.positive,
      'warning' => InsightType.warning,
      _ => InsightType.tip,
    };
    return AiInsight(type: type, text: json['text'] as String? ?? '');
  }
}
