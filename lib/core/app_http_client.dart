import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:lumimoney_app/core/exceptions/app_exception.dart';
import 'package:lumimoney_app/core/config.dart';
import 'package:lumimoney_app/core/global_event_bus.dart';

class AppHttpClient {
  final Dio _dio = Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl));

  AppHttpClient() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final skipAuth =
              options.path.contains('/auth/login') ||
              options.path.contains('/auth/register');

          if (!skipAuth) {
            final token = await _getToken();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }

          handler.next(options);
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
            _handleUnauthorized();
          }
          handler.next(e);
        },
      ),
    );
  }

  Future<Response> post(String path, {Map<String, dynamic>? data}) async {
    return _handleRequest(() => _dio.post(path, data: data));
  }

  Future<Response> get(String path) async {
    return _handleRequest(() => _dio.get(path));
  }

  Future<Response> put(String path, {Map<String, dynamic>? data}) async {
    return _handleRequest(() => _dio.put(path, data: data));
  }

  Future<Response> delete(String path) async {
    return _handleRequest(() => _dio.delete(path));
  }

  Future<Response> _handleRequest(Future<Response> Function() request) async {
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
    Hive.box('userBox').clear();
    globalEventBus.fire(GlobalEvent.loggedOut);
  }

  Future<String?> _getToken() async {
    final box = await Hive.openBox('userBox');
    return box.get('token') as String?;
  }
}
