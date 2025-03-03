import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lumimoney_app/core/global_event_bus.dart';
import 'package:lumimoney_app/features/auth/providers/auth_provider.dart';
import 'package:lumimoney_app/core/router.dart';
import 'package:lumimoney_app/core/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final container = ProviderContainer();

  await container.read(authProvider.notifier).loadUserFromStorage();

  globalEventBus.on<String>().listen((event) {
    final context = router.routerDelegate.navigatorKey.currentContext;
    if (context != null && event == GlobalEvent.loggedOut) {
      router.pushReplacement('/login');
    }
  });

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
