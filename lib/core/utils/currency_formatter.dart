import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static String format(double amount) {
    final formatter = NumberFormat('#,##0.##', 'ar_EG');
    return '${formatter.format(amount)} ج.م';
  }

  static String formatPlain(double amount) {
    final formatter = NumberFormat('#,##0.##', 'en_US');
    return '${formatter.format(amount)} ج.م';
  }
}
