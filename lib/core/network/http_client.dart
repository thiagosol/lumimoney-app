import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumimoney_app/core/storage/secure_storage.dart';
import 'package:lumimoney_app/core/utils/global_event_bus.dart' as events;
import 'package:lumimoney_app/core/exceptions/app_exception.dart';
import 'package:lumimoney_app/core/network/api_endpoints.dart';
import 'package:lumimoney_app/shared/events/global_event.dart' as shared_events;

final appHttpClientProvider = Provider<AppHttpClient>((ref) {
  return AppHttpClient();
});

class AppHttpClient {
  final Dio _dio;

  AppHttpClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiEndpoints.baseUrl,
            connectTimeout: const Duration(seconds: 5),
            receiveTimeout: const Duration(seconds: 3),
          ),
        ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onError: _onError,
      ),
    );
  }

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await SecureStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  Future<void> _onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final isAuthRoute = _isAuthenticationRoute(err.requestOptions.path);
    if (!isAuthRoute &&
        (err.response?.statusCode == 401 || err.response?.statusCode == 403)) {
      _handleUnauthorized();
    }
    handler.next(err);
  }

  bool _isAuthenticationRoute(String path) {
    return path == ApiEndpoints.login ||
        path == ApiEndpoints.register ||
        path == ApiEndpoints.googleLogin;
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _handleRequest(
      () => _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _handleRequest(
      () => _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  Future<String?> getToken() async {
    return SecureStorage.getToken();
  }

  Future<Response> put(String path, {Map<String, dynamic>? data}) async {
    return _handleRequest(() => _dio.put(path, data: data));
  }

  Future<Response> delete(String path) async {
    return _handleRequest(() => _dio.delete(path));
  }

  Future<Response<T>> _handleRequest<T>(
    Future<Response<T>> Function() request,
  ) async {
    try {
      return await request();
    } on DioException catch (e) {
      throw AppException(_extractErrorMessage(e), e);
    } on Exception catch (e) {
      throw AppException('Erro inesperado ao realizar a requisição.', e);
    }
  }

  String _extractErrorMessage(DioException e) {
    if (e.response != null && e.response?.data is Map<String, dynamic>) {
      final data = e.response?.data as Map<String, dynamic>;
      if (data.containsKey('message')) {
        return data['message'].toString();
      }
    }
    return 'Erro inesperado ao realizar a requisição';
  }

  void _handleUnauthorized() {
    SecureStorage.clearAll();
    events.globalEventBus.fire(shared_events.GlobalEvent.loggedOut);
  }
}
