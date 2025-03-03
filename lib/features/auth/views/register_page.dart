import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumimoney_app/features/auth/controllers/register_controller.dart';
import 'package:lumimoney_app/features/auth/providers/auth_provider.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPage();
}

class _RegisterPage extends ConsumerState<RegisterPage> {
  final RegisterController _registerController = RegisterController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    ref.listen(authProvider, (previous, next) {
      if (previous?.isLoading == true &&
          next.isLoading == false &&
          next.user?.email != null &&
          next.error == null) {
        context.go('/login');
      } else if (next.error != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error!)));
      }
    });

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
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Criar Conta',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6A5ACD),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emailController,
                        autofillHints: [AutofillHints.email],
                        decoration: const InputDecoration(labelText: 'E-mail'),
                        validator: _registerController.emailValidator,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordController,
                        autofillHints: [AutofillHints.password],
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'Senha'),
                        validator: _registerController.passwordValidator,
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
                                    _registerController.register(
                                      _formKey,
                                      _emailController.text,
                                      _passwordController.text,
                                      ref,
                                    );
                                  },
                                  child: const Text('Registrar'),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextButton(
                                onPressed: () => context.pushReplacement('/login'),
                                child: const Text(
                                  'Já tem uma conta? Faça login',
                                ),
                              ),
                            ],
                          ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
