import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumimoney_app/features/auth/providers/auth_provider.dart';

class AuthWrapper extends ConsumerWidget {
  final Widget child;

  const AuthWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authState.user == null) {
        context.go('/login');
      }
    });

    return child;
  }
}
