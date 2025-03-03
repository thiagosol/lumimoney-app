import 'package:dio/dio.dart';
import 'package:lumimoney_app/core/exceptions/app_exception.dart';
import 'package:lumimoney_app/core/config.dart';

class HttpClientService {
  final Dio _dio = Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl));

  HttpClientService();

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
      throw AppException("Erro inesperado ao realizar a requisição.", e);
    }
  }

  String _extractErrorMessage(DioException e) {
    if (e.response != null && e.response?.data is Map<String, dynamic>) {
      final data = e.response?.data as Map<String, dynamic>;
      if (data.containsKey('message')) {
        return data['message'].toString();
      }
    }
    return "Erro inesperado ao realizar a requisição";
  }
}
