class Env {
  static const String _defaultApiBaseUrl =
      'https://api-lumimoney.thiagosol.com';
  static String get apiBaseUrl => const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: _defaultApiBaseUrl,
      );
}
