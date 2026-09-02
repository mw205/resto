import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String formatDate(DateTime dateTime) {
    return DateFormat('yyyy/MM/dd - hh:mm a', 'ar').format(dateTime);
  }

  static String formatShortDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy', 'ar').format(dateTime);
  }

  static String formatTime(DateTime dateTime) {
    return DateFormat('hh:mm a', 'ar').format(dateTime);
  }
}
