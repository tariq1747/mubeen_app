import 'package:intl/intl.dart';

/// Centralised date formatting so every screen shows dates consistently.
class AppDateUtils {
  AppDateUtils._();

  static String format(DateTime date) => DateFormat('dd MMM yyyy').format(date);

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
