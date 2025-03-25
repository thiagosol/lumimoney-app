import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:lumimoney_app/network/http_client.dart';
import 'package:lumimoney_app/exceptions/app_exception.dart';
import 'package:lumimoney_app/service/openid/io.dart'
    if (dart.library.js_interop) 'package:lumimoney_app/service/openid/browser.dart';

import 'package:lumimoney_app/storage/secure_storage.dart';
import 'package:lumimoney_app/models/user.dart';
import 'package:lumimoney_app/network/api_endpoints.dart';
import 'package:openid_client/openid_client.dart';

class AuthService {
  final AppHttpClient client;

  Client? _openidClient;

  AuthService(this.client);

  static const String _clientId = 'lumimoney-app';
  static const List<String> _scopes = ['openid', 'email', 'profile'];

  Future<void> _initializeClient() async {
    if (_openidClient != null) return;

    final issuer = await Issuer.discover(Uri.parse(ApiEndpoints.issuerUrl));
    _openidClient = Client(issuer, _clientId);
  }

  Future<String?> login() async {
    if (kIsWeb) {
      return await loginWeb();
    } else {
      return await loginApp();
    }
  }

  Future<String?> loginWeb() async {
    await _initializeClient();
    await authenticate(_openidClient!, scopes: _scopes);
    return null;
  }

  Future<String?> loginWebResult() async {
    await _initializeClient();
    var credential = await getRedirectResult(_openidClient!, scopes: _scopes);
    return (await credential?.getTokenResponse())?.accessToken;
  }

  Future<String?> loginApp() async {
    await _initializeClient();
    var credential = await authenticate(_openidClient!, scopes: _scopes);
    return (await credential.getTokenResponse()).accessToken;
  }

  Future<void> logout() async {
    SecureStorage.clearAll();
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
