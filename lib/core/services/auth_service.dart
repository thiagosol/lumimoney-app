import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openid_client/openid_client_browser.dart';
import 'package:lumimoney_app/core/storage/secure_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:lumimoney_app/core/network/api_endpoints.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

class AuthService {
  static const String _clientId = 'lumimoney';
  static const List<String> _scopes = ['openid', 'email', 'profile'];

  Client? _client;
  Authenticator? _authenticator;

  AuthService();

  Future<void> _initializeClient() async {
    if (_client != null) return;

    final issuer = await Issuer.discover(Uri.parse(ApiEndpoints.issuerUrl));
    _client = Client(issuer, _clientId);
  }

  Future<String?> login() async {
    await _initializeClient();
    if (_client == null) return null;

    if (!kIsWeb) {
      throw UnsupportedError('Este fluxo só é suportado na web');
    }

    _authenticator = Authenticator(
      _client!,
      scopes: _scopes,
    );

    final credential = await _authenticator!.credential;

    if (credential == null) {
      _authenticator!.authorize();
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
    _client = null;
    _authenticator = null;
  }
}
