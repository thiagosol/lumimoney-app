import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumimoney_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:lumimoney_app/shared/constants/app_constants.dart';

class AuthWrapper extends ConsumerStatefulWidget {
  final Widget child;

  const AuthWrapper({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends ConsumerState<AuthWrapper> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuth();
    });
  }

  Future<void> _checkAuth() async {
    if (!_initialized) {
      _initialized = true;
      await ref.read(authControllerProvider.notifier).checkAuthState();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    if (!_initialized || authState.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (authState.user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(AppConstants.loginRoute);
      });
      return const SizedBox.shrink();
    }

    return widget.child;
  }
}
