import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static String formatDateLabel(DateTime date) {
    if (isSameDay(date, DateTime.now())) return 'Today';
    return DateFormat('MMM d, yyyy').format(date);
  }
}
