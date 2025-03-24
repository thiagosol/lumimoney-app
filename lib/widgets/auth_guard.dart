import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumimoney_app/storage/secure_storage.dart';
import 'package:lumimoney_app/controllers/auth_controller.dart';
import 'package:lumimoney_app/constants/app_constants.dart';
import 'dart:html' if (dart.library.io) 'dart:io' as platform;

class AuthGuard extends ConsumerStatefulWidget {
  const AuthGuard({super.key});

  @override
  ConsumerState<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends ConsumerState<AuthGuard> {
  @override
  void initState() {
    super.initState();
    _checkKeycloakCallback();
  }

  Future<void> _checkKeycloakCallback() async {
    final uri = Uri.parse(platform.window.location.href);

    if (uri.hasFragment) {
      final fragmentParams = Uri.splitQueryString(uri.fragment);

      if (fragmentParams.containsKey('access_token')) {
        final token = fragmentParams['access_token'];
        if (token != null) {
          await SecureStorage.saveToken(token);
          if (mounted) {
            context.go(AppConstants.homeRoute);
            return;
          }
        }
      }
    }

    if (mounted) {
      context.go(AppConstants.loginRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
