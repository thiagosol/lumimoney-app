class Validators {
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    return emailRegex.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  static bool isValidCurrency(String value) {
    final currencyRegex = RegExp(r'^\d+[.,]?\d{0,2}$');
    return currencyRegex.hasMatch(value);
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName é obrigatório';
    }
    return null;
  }

  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'E-mail é obrigatório';
    }
    if (!isValidEmail(email)) {
      return 'E-mail inválido';
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Senha é obrigatória';
    }
    if (!isValidPassword(password)) {
      return 'Senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }
}
