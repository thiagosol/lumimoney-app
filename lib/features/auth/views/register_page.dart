import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumimoney_app/features/auth/providers/auth_provider.dart';

class RegisterPage extends ConsumerWidget {
  RegisterPage({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          final formWidth = isMobile ? double.infinity : 400.0;

          return Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              width: formWidth,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Criar Conta",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6A5ACD),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: "E-mail"),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: "Senha"),
                    ),
                    const SizedBox(height: 24),
                    authState.isLoading
                        ? const CircularProgressIndicator()
                        : Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () {
                                  ref
                                      .read(authProvider.notifier)
                                      .register(
                                        emailController.text,
                                        passwordController.text,
                                      );
                                },
                                child: const Text("Registrar"),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () => context.push("/login"),
                              child: const Text("Já tem uma conta? Faça login"),
                            ),
                          ],
                        ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
