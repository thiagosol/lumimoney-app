import 'package:lumimoney_app/core/network/http_client.dart';
import 'package:lumimoney_app/core/exceptions/app_exception.dart';
import 'package:lumimoney_app/features/auth/data/models/user_model.dart';
import 'package:lumimoney_app/core/network/api_endpoints.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AppHttpClient client;

  AuthRemoteDataSourceImpl(this.client);

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await client.get(ApiEndpoints.userInfo);
      final token = await client.getToken();

      if (token == null) {
        throw AppException('Usuário não autenticado');
      }

      return UserModel(
        id: response.data['sub'],
        email: response.data['email'],
        role: 'user',
        token: token,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Falha ao obter dados do usuário');
    }
  }
}
