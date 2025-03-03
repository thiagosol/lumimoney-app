import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumimoney_app/core/controllers/validator_controller.dart';
import 'package:lumimoney_app/features/auth/providers/auth_provider.dart';

class RegisterController {
  final ValidatorController _validatorController = ValidatorController();
  
  RegisterController();

  Future<void> register(
    GlobalKey<FormState> formKey,
    String email,
    String password,
    WidgetRef ref,
  ) async {
    if (formKey.currentState?.validate() ?? false) {
      final authNotifier = ref.read(authProvider.notifier);
      authNotifier.register(email, password);
    }
  }

  String? emailValidator(String? value) {
    return _validatorController.emptyValidator(value, 'Informe sua email');
  }

  String? passwordValidator(String? value) {
    return _validatorController.emptyValidator(value, 'Informe sua senha');
  }
}
