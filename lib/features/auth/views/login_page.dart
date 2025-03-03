import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumimoney_app/features/auth/providers/auth_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final authState = ref.read(authProvider);
    if (authState.user?.email != null) {
      emailController.text = authState.user!.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);

    ref.listen(authProvider, (previous, next) {
      if (previous?.isLoading == true &&
          next.isLoading == false &&
          next.user != null) {
        context.go('/home');
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "LumiMoney",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6A5ACD),
                      ),
                    ),
                    const SizedBox(height: 16),
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
                                  authNotifier.login(
                                    emailController.text,
                                    passwordController.text,
                                  );
                                },
                                child: const Text("Entrar"),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              height: 40,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  final googleSignIn = GoogleSignIn(
                                    clientId:
                                        kIsWeb
                                            ? '267276050562-6olehn76rf4t03ap7m2gu3987id3q6k3.apps.googleusercontent.com'
                                            : null,
                                    scopes: ['email', 'profile', 'openid'],
                                  );

                                  final googleUser =
                                      await googleSignIn.signIn();
                                  if (googleUser == null) return;

                                  final auth = await googleUser.authentication;
                                  final accessToken = auth.accessToken;

                                  if (accessToken != null) {
                                    ref
                                        .read(authProvider.notifier)
                                        .loginWithGoogle(
                                          googleUser.email,
                                          accessToken,
                                        );
                                  }
                                },
                                icon: Image.asset(
                                  'assets/google_logo.png',
                                  height: 24,
                                ),
                                label: const Text('Entrar com Google'),
                              ),
                            ),
                            TextButton(
                              onPressed: () => context.push("/register"),
                              child: const Text("Criar conta"),
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
