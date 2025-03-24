class AppConstants {
  // Configurações gerais
  static const String appName = 'LumiMoney';
  static const String appVersion = '1.0.0';

  // Mensagens
  static const String defaultErrorMessage = 'Ocorreu um erro inesperado';
  static const String networkErrorMessage = 'Erro de conexão';
  static const String sessionExpiredMessage = 'Sua sessão expirou';

  // Rotas
  static const String homeRoute = '/';
  static const String loginRoute = '/login';
  static const String transactionsRoute = '/transactions';
  static const String addAccountRoute = '/add-account';
  static const String addCardRoute = '/add-card';
  static const String addTransactionRoute = '/add-transaction';

  // Formatação
  static const String dateFormat = 'dd/MM/yyyy';
  static const String currencyFormat = 'R\$';
}
