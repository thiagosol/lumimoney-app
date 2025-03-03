import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumimoney_app/features/auth/providers/auth_provider.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Home",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF6A5ACD)),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
