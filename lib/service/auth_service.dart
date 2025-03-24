import 'package:flutter/foundation.dart';
import 'package:lumimoney_app/network/http_client.dart';
import 'package:lumimoney_app/exceptions/app_exception.dart';
import 'package:lumimoney_app/storage/secure_storage.dart';
import 'package:lumimoney_app/models/user.dart';
import 'package:lumimoney_app/network/api_endpoints.dart';
import 'package:openid_client/openid_client_browser.dart';

class AuthService {
  final AppHttpClient client;

  Client? _openidClient;
  Authenticator? _openidAuthenticator;

  AuthService(this.client);

  static const String _clientId = 'lumimoney';
  static const List<String> _scopes = ['openid', 'email', 'profile'];

  Future<void> _initializeClient() async {
    if (_openidClient != null) return;

    final issuer = await Issuer.discover(Uri.parse(ApiEndpoints.issuerUrl));
    _openidClient = Client(issuer, _clientId);
  }

  Future<String?> login() async {
    await _initializeClient();
    if (_openidClient == null) return null;

    if (!kIsWeb) {
      throw UnsupportedError('Este fluxo só é suportado na web');
    }

    _openidAuthenticator = Authenticator(
      _openidClient!,
      scopes: _scopes,
    );

    final credential = await _openidAuthenticator!.credential;

    if (credential == null) {
      _openidAuthenticator!.authorize();
      return null;
    }

    final tokenResponse = await credential.getTokenResponse();
    if (tokenResponse.accessToken != null) {
      await SecureStorage.saveToken(tokenResponse.accessToken!);
      return tokenResponse.accessToken;
    }

    return null;
  }

  Future<void> saveToken(String token) async {
    await SecureStorage.saveToken(token);
  }

  Future<void> logout() async {
    await SecureStorage.clearAll();
    _openidClient = null;
    _openidAuthenticator = null;
  }

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
