class AppSpacing {
  AppSpacing._();

  static const double pagePadding = 24;
  static const double cardPadding = 16;
  static const double sectionGap = 32;
  static const double itemGap = 16;
  static const double smallGap = 8;
}

class AppPagination {
  AppPagination._();

  static const int defaultPageSize = 15;
  static const double scrollLoadThreshold = 200;
}

class AppTimeouts {
  AppTimeouts._();

  static const Duration habitWrite = Duration(seconds: 15);
  static const Duration habitToggle = Duration(seconds: 10);
  static const Duration aiGeneration = Duration(seconds: 30);
}

class AppErrorMessages {
  AppErrorMessages._();

  static const String timeout =
      'Request timed out. Please check your connection and try again.';
  static const String saveFailed = 'Failed to save. Please try again.';
  static const String generateFailed =
      'Could not generate habits. Please try again.';
  static const String genericError =
      'Something went wrong. Please try again.';
}
