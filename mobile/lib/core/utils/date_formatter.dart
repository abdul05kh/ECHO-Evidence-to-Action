import 'package:intl/intl.dart';

/// Standardized date & timestamp formatting utility for ECHO.
class EchoDateFormatter {
  static final DateFormat _timeFormat = DateFormat('h:mm a');
  static final DateFormat _dateFormat = DateFormat('MMM d, yyyy');
  static final DateFormat _fullFormat = DateFormat('MMM d, yyyy • h:mm a');

  static String formatTime(DateTime dateTime) {
    return _timeFormat.format(dateTime.toLocal());
  }

  static String formatDate(DateTime dateTime) {
    return _dateFormat.format(dateTime.toLocal());
  }

  static String formatFull(DateTime dateTime) {
    return _fullFormat.format(dateTime.toLocal());
  }

  static String formatRelative(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final mins = difference.inMinutes;
      return '$mins ${mins == 1 ? "min" : "mins"} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? "hr" : "hrs"} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? "day" : "days"} ago';
    } else {
      return formatDate(dateTime);
    }
  }
}
