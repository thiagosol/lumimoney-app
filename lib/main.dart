import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lumimoney_app/features/auth/providers/auth_provider.dart';
import 'core/router.dart';
import 'core/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final container = ProviderContainer();

  await container.read(authProvider.notifier).loadUserFromStorage();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const LumiMoneyApp(),
    ),
  );
}

class LumiMoneyApp extends StatelessWidget {
  const LumiMoneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
    );
  }
}
