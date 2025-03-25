import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumimoney_app/controllers/auth_controller.dart';
import 'package:lumimoney_app/constants/app_constants.dart';

class AuthGuard extends ConsumerStatefulWidget {
  const AuthGuard({super.key});

  @override
  ConsumerState<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends ConsumerState<AuthGuard> {
  @override
  void initState() {
    super.initState();
    _checkLoginCallback();
  }

  Future<void> _checkLoginCallback() async {
    try {
      if (kIsWeb) {
        await ref.read(authControllerProvider.notifier).loginWebResult(context);
      }
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
      context.go(AppConstants.homeRoute);
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
