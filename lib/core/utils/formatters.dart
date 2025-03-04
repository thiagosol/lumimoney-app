import 'package:intl/intl.dart';
import 'package:lumimoney_app/shared/constants/app_constants.dart';

class Formatters {
  static String formatCurrency(double value) {
    final formatter = NumberFormat.currency(
      symbol: AppConstants.currencyFormat,
      decimalDigits: 2,
      locale: 'pt_BR',
    );
    return formatter.format(value);
  }

  static String formatDate(DateTime date) {
    return DateFormat(AppConstants.dateFormat).format(date);
  }

  static String formatDateFromString(String date) {
    final dateTime = DateTime.parse(date);
    return formatDate(dateTime);
  }
}
