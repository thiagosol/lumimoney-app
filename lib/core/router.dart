import 'package:go_router/go_router.dart';
import 'package:lumimoney_app/features/auth/auth_wrapper.dart';
import 'package:lumimoney_app/features/auth/views/login_page.dart';
import 'package:lumimoney_app/features/auth/views/register_page.dart';
import 'package:lumimoney_app/features/home/views/home_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const AuthWrapper(child: HomePage()),
    ),
  ],
);
