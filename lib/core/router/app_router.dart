import 'package:go_router/go_router.dart';
import 'package:lumimoney_app/features/auth/presentation/pages/login_page.dart';
import 'package:lumimoney_app/features/auth/presentation/pages/register_page.dart';
import 'package:lumimoney_app/features/auth/presentation/widgets/auth_wrapper.dart';
import 'package:lumimoney_app/features/home/presentation/pages/home_page.dart';
import 'package:lumimoney_app/features/payment_methods/presentation/pages/add_account_page.dart';
import 'package:lumimoney_app/features/payment_methods/presentation/pages/add_card_page.dart';
import 'package:lumimoney_app/features/transactions/presentation/pages/add_transaction_page.dart';
import 'package:lumimoney_app/features/transactions/presentation/pages/transactions_page.dart';
import 'package:lumimoney_app/shared/constants/app_constants.dart';

final appRouter = GoRouter(
  initialLocation: AppConstants.homeRoute,
  routes: [
    GoRoute(
      path: AppConstants.loginRoute,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppConstants.registerRoute,
      builder: (context, state) => const RegisterPage(),
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
);
