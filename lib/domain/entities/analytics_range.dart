enum AnalyticsRange {
  last7,
  last30,
  last90;

  int get days {
    switch (this) {
      case AnalyticsRange.last7:
        return 7;
      case AnalyticsRange.last30:
        return 30;
      case AnalyticsRange.last90:
        return 90;
    }
  }

  String get label {
    switch (this) {
      case AnalyticsRange.last7:
        return '7D';
      case AnalyticsRange.last30:
        return '30D';
      case AnalyticsRange.last90:
        return '90D';
    }
  }
}
