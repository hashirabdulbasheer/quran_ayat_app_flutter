import 'package:ayat_app/src/core/di/service_locator.dart';
import 'package:ayat_app/src/core/navigator/app_router.dart';
import 'package:ayat_app/src/core/theme/theme.dart';
import 'package:ayat_app/src/core/utils/app_bloc_observer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

// TODO: Update before release
const String appVersion = "v4.0.1";

void main() {
  usePathUrlStrategy();
  configDependencies();
  setupServicesLocator();
  if (kDebugMode) Bloc.observer = AppBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Quran',
      theme: QTheme.lightTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
}
