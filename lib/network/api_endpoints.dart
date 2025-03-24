import 'package:lumimoney_app/config/env.dart';

class ApiEndpoints {
  static String get issuerUrl =>
      'https://auth.thiagosol.com/realms/thiagosol.com';
  static String get baseUrl => Env.apiBaseUrl;

  // Login
  static String get userInfo => '$issuerUrl/protocol/openid-connect/userinfo';

  // Payment Methods
  static String get paymentMethods => '$baseUrl/payment-methods';

  // Credit Card Invoices
  static String get creditCardInvoices => '$baseUrl/credit-card-invoices';

  // Transactions
  static String get transactions => '$baseUrl/transactions';
}
