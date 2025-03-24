class MoneyFormatter {
  static String format(String value) {
    if (value.isEmpty) {
      return '0,00';
    }

    final numbers = value.replaceAll(RegExp(r'[^\d]'), '');

    if (numbers.isEmpty) {
      return '0,00';
    }

    final amount = int.parse(numbers);

    final formatted = (amount / 100).toStringAsFixed(2);
    final parts = formatted.split('.');

    final wholePart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );

    return '$wholePart,${parts[1]}';
  }

  static double parse(String value) {
    final cleanValue = value.replaceAll('.', '').replaceAll(',', '.');
    return double.parse(cleanValue);
  }
}
