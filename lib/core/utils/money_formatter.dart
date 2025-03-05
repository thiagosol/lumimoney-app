class MoneyFormatter {
  static String format(String value) {
    if (value.isEmpty) {
      return '0,00';
    }

    // Remove todos os caracteres não numéricos
    final numbers = value.replaceAll(RegExp(r'[^\d]'), '');
    
    // Se não tiver números, mantém 0,00
    if (numbers.isEmpty) {
      return '0,00';
    }

    // Converte para inteiro
    final amount = int.parse(numbers);
    
    // Formata o valor
    final formatted = (amount / 100).toStringAsFixed(2);
    final parts = formatted.split('.');
    
    // Adiciona os pontos para milhares
    final wholePart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
    
    return '$wholePart,${parts[1]}';
  }

  static double parse(String value) {
    final cleanValue = value
        .replaceAll('.', '')
        .replaceAll(',', '.');
    return double.parse(cleanValue);
  }
} 