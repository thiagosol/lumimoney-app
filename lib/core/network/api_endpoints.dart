import 'package:lumimoney_app/core/config/env.dart';

class ApiEndpoints {
  static String get baseUrl => Env.apiBaseUrl;

  // Users
  static String get login => '$baseUrl/users/login';
  static String get register => '$baseUrl/users/register';
  static String get me => '$baseUrl/users/me';

  // Auth Google
  static String get googleLogin => '$baseUrl/auth/google';

  // Payment Methods
  static String get paymentMethods => '$baseUrl/payment-methods';

  // Adicione outros endpoints conforme necessário
}
