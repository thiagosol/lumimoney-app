import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lumimoney_app/core/controllers/validator_controller.dart';
import 'package:lumimoney_app/features/auth/providers/auth_provider.dart';

class LoginController {
  final ValidatorController _validatorController = ValidatorController();

  LoginController();

  Future<void> login(
    GlobalKey<FormState> formKey,
    String email,
    String password,
    WidgetRef ref,
  ) async {
    if (formKey.currentState?.validate() ?? false) {
      final authNotifier = ref.read(authProvider.notifier);
      authNotifier.login(email, password);
    }
  }

  Future<void> loginWithGoogle(WidgetRef ref) async {
    final authNotifier = ref.read(authProvider.notifier);
    final googleSignIn = GoogleSignIn(
      clientId:
          kIsWeb
              ? '267276050562-6olehn76rf4t03ap7m2gu3987id3q6k3.apps.googleusercontent.com'
              : null,
      scopes: ['email', 'profile', 'openid'],
    );

    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;

    final auth = await googleUser.authentication;
    final accessToken = auth.accessToken;

    if (accessToken != null) {
      authNotifier.loginWithGoogle(googleUser.email, accessToken);
    }
  }

  String? emailValidator(String? value) {
    return _validatorController.emptyValidator(value, 'Informe sua email');
  }

  String? passwordValidator(String? value) {
    return _validatorController.emptyValidator(value, 'Informe sua senha');
  }
}
