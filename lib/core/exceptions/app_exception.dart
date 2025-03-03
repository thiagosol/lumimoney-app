class AppException implements Exception {
  final String message;
  final Exception? exception;

  AppException(this.message, [this.exception]);

  @override
  String toString() => message;
}
