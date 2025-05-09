import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lumimoney_app/router/app_router.dart';
import 'package:lumimoney_app/theme/app_theme.dart';
import 'package:lumimoney_app/events/global_event_bus.dart';
import 'package:lumimoney_app/constants/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('userBox');
  await initializeDateFormatting('pt_BR', null);

  runApp(
    const ProviderScope(
      child: LumiMoneyApp(),
    ),
  );
}

class LumiMoneyApp extends ConsumerStatefulWidget {
  const LumiMoneyApp({super.key});

  @override
  ConsumerState<LumiMoneyApp> createState() => _LumiMoneyAppState();
}

class _LumiMoneyAppState extends ConsumerState<LumiMoneyApp> {
  @override
  void initState() {
    super.initState();
    _setupGlobalEventListener();
  }

  void _setupGlobalEventListener() {
    globalEventBus.on<GlobalEvent>().listen((event) {
      if (event == GlobalEvent.loggedOut && mounted) {
        appRouter.go(AppConstants.loginRoute);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'LumiMoney',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: appRouter,
    );
  }
}
