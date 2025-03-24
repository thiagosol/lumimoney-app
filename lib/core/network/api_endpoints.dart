import 'package:lumimoney_app/core/config/env.dart';

class ApiEndpoints {
  static String get issuerUrl =>
      'https://auth.thiagosol.com/realms/thiagosol.com';
  static String get baseUrl => Env.apiBaseUrl;

  // Login
  static String get userInfo => '$issuerUrl/protocol/openid-connect/userinfo';

  // Payment Methods
  static String get paymentMethods => '$baseUrl/payment-methods';

  // Adicione outros endpoints conforme necessário
}
