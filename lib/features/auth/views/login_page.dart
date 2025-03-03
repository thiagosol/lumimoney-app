import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumimoney_app/features/auth/controllers/login_controller.dart';
import 'package:lumimoney_app/features/auth/providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final LoginController _loginController = LoginController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    final authState = ref.read(authProvider);
    if (authState.user?.email != null) {
      _emailController.text = authState.user!.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen(authProvider, (previous, next) {
      if (previous?.isLoading == true &&
          next.isLoading == false &&
          next.user?.token != null) {
        context.pushReplacement('/home');
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
                        'LumiMoney',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6A5ACD),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        autofillHints: [AutofillHints.email],
                        decoration: const InputDecoration(labelText: 'E-mail'),
                        validator: _loginController.emailValidator,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordController,
                        autofillHints: [AutofillHints.password],
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'Senha'),
                        validator: _loginController.passwordValidator,
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
                                    _loginController.login(
                                      _formKey,
                                      _emailController.text,
                                      _passwordController.text,
                                      ref,
                                    );
                                  },
                                  child: const Text('Entrar'),
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                height: 40,
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    _loginController.loginWithGoogle(ref);
                                  },
                                  icon: Image.asset(
                                    'assets/google_logo.png',
                                    height: 24,
                                  ),
                                  label: const Text('Entrar com Google'),
                                ),
                              ),
                              TextButton(
                                onPressed: () => context.pushReplacement('/register'),
                                child: const Text('Criar conta'),
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
