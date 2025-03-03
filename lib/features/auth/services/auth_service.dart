import 'package:lumimoney_app/core/exceptions/app_exception.dart';
import 'package:lumimoney_app/core/app_http_client.dart';

class AuthService {
  final AppHttpClient _http = AppHttpClient();

  Future<String> login(String email, String password) async {
    final response = await _http.post('/auth/login', data: {
      'email': email,
      'password': password,
    },);

    if (response.statusCode != 200) {
      throw AppException('Erro ao fazer login');
    }
    return response.data['token'];
  }

  register(String email, String password) async {
    final response = await _http.post('/auth/register', data: {
      'email': email,
      'password': password,
    },);

    if (response.statusCode != 201) {
      throw AppException('Erro ao registrar usuário');
    }
  }

  Future<String> loginWithGoogle(String googleAccessToken) async {
    final response = await _http.post('/auth/google', data: {
      'token': googleAccessToken,
    },);

    if (response.statusCode != 200) {
      throw AppException('Erro ao logar com Google');
    }

    return response.data['token'];
  }
}
