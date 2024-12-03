import 'package:ayat_app/src/core/di/service_locator.dart';
import 'package:ayat_app/src/core/navigator/app_router.dart';
import 'package:ayat_app/src/core/utils/app_bloc_observer.dart';
import 'package:ayat_app/src/presentation/home/home.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

import 'src/core/utils/stub.dart'
    if (dart.library.html) 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initialize();
  runApp(BlocProvider(
      create: (context) => getIt<AppBloc>()..add(AppInitializeEvent()),
      child: const MyApp()));
}

Future _initialize() async {
  await setupServicesLocator();
  usePathUrlStrategy();
  configDependencies();
  if (kDebugMode) Bloc.observer = AppBlocObserver();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ThemeMode>(
        stream: context.read<AppBloc>().currentThemeMode$,
        builder: (context, snapshot) {
          return MaterialApp.router(
            title: 'Quran',
            theme: FlexThemeData.light(scheme: FlexScheme.green),
            darkTheme: FlexThemeData.dark(scheme: FlexScheme.green),
            themeMode: snapshot.data ?? ThemeMode.light,
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.router,
          );
        });
  }
}
