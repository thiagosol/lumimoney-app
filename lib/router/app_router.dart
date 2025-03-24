import 'package:go_router/go_router.dart';
import 'package:lumimoney_app/pages/login_page.dart';
import 'package:lumimoney_app/widgets/auth_wrapper.dart';
import 'package:lumimoney_app/pages/home_page.dart';
import 'package:lumimoney_app/pages/add_account_page.dart';
import 'package:lumimoney_app/pages/add_card_page.dart';
import 'package:lumimoney_app/pages/add_transaction_page.dart';
import 'package:lumimoney_app/pages/transactions_page.dart';
import 'package:lumimoney_app/constants/app_constants.dart';
import 'package:lumimoney_app/widgets/auth_guard.dart';

final appRouter = GoRouter(
  initialLocation: AppConstants.homeRoute,
  routes: [
    GoRoute(
      path: AppConstants.loginRoute,
      builder: (context, state) => const LoginPage(),
    ),
    ShellRoute(
      builder: (context, state, child) => AuthWrapper(child: child),
      routes: [
        GoRoute(
          path: AppConstants.homeRoute,
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: AppConstants.addAccountRoute,
          builder: (context, state) => const AddAccountPage(),
        ),
        GoRoute(
          path: AppConstants.addCardRoute,
          builder: (context, state) => const AddCardPage(),
        ),
        GoRoute(
          path: AppConstants.addTransactionRoute,
          builder: (context, state) => const AddTransactionPage(),
        ),
        GoRoute(
          path: AppConstants.transactionsRoute,
          builder: (context, state) {
            final type = state.uri.queryParameters['type'];
            final id = state.uri.queryParameters['id'];
            return TransactionsPage(type: type, id: id);
          },
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => const AuthGuard(),
);
