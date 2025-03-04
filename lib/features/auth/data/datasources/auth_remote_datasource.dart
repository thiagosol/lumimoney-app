import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lumimoney_app/core/network/http_client.dart';
import 'package:lumimoney_app/core/network/api_endpoints.dart';
import 'package:lumimoney_app/core/exceptions/app_exception.dart';
import 'package:lumimoney_app/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<void> register(String email, String password);
  Future<UserModel> loginWithGoogle();
  Future<UserModel> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AppHttpClient client;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSourceImpl(this.client)
      : _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await client.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.data['token'] == null) {
        throw AppException(response.data['message'] ?? 'Falha ao realizar login');
      }

      final token = response.data['token'] as String;
      final userResponse = await client.get(
        ApiEndpoints.me,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return UserModel.fromJson(userResponse.data, token: token);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Falha ao realizar login');
    }
  }

  @override
  Future<void> register(String email, String password) async {
    try {
      final response = await client.post(
        ApiEndpoints.register,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode != 201) {
        throw AppException(response.data['message'] ?? 'Falha ao realizar cadastro');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Falha ao realizar cadastro');
    }
  }

  @override
  Future<UserModel> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw AppException('Login com Google cancelado');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final response = await client.post(
        ApiEndpoints.googleLogin,
        data: {
          'token': googleAuth.accessToken,
        },
      );

      if (response.data['token'] == null) {
        throw AppException(response.data['message'] ?? 'Falha ao realizar login com Google');
      }

      final token = response.data['token'] as String;
      final userResponse = await client.get(
        ApiEndpoints.me,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return UserModel.fromJson(userResponse.data, token: token);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Falha ao realizar login com Google');
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await client.get(ApiEndpoints.me);
      final token = await client.getToken();

      if (token == null) {
        throw AppException('Usuário não autenticado');
      }

      return UserModel.fromJson(response.data, token: token);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Falha ao obter dados do usuário');
    }
  }
}
