import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:noble_quran/models/word.dart';
import 'package:noble_quran/noble_quran.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'composer.dart';
import 'features/auth/domain/auth_factory.dart';
import 'features/core/domain/app_state/app_state.dart';
import 'features/notes/data/hive_notes_impl.dart';
import 'features/notes/domain/redux/middleware/middleware.dart';
import 'features/tags/domain/redux/middleware/middleware.dart';
import 'utils/logger_utils.dart';
import 'utils/search_utils.dart';
import 'misc/url/url_strategy.dart';
import 'features/settings/domain/theme_manager.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:redux/redux.dart';

// TODO: Update before release
const String appVersion = "v2.6.3";

void main() async {
  runZonedGuarded(
    () async {
      usePathUrlStrategy();
      WidgetsFlutterBinding.ensureInitialized();
      await QuranHiveNotesEngine.instance.initialize();
      await QuranAuthFactory.engine.initialize();
      FirebaseAnalytics.instance.logAppOpen();
      await SentryFlutter.init(
        (options) {
          // options.environment = 'develop';
          options.release = 'quran-ayat-app@$appVersion';
          options.tracesSampleRate = 1.0;
        },
      );

      runApp(MyApp(
        homeScreen: StoreBuilder<AppState>(
          rebuildOnChange: false,
          onInit: (store) => store.dispatch(AppStateInitializeAction()),
          builder: (
            BuildContext context,
            Store<AppState> store,
          ) =>
              QuranComposer.composeAyatScreen(),
        ),
      ));

      _loadQuranWords();
    },
    (
      exception,
      stackTrace,
    ) async {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
    },
  );
}

class MyApp extends StatefulWidget {
  final Widget homeScreen;

  const MyApp({
    Key? key,
    required this.homeScreen,
  }) : super(key: key);

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final store = Store(
    appStateReducer,
    distinct: true,
    initialState: const AppState(),
    middleware: [
      appStateMiddleware,
      LoggerMiddleware<AppState>(),
      ...createTagOperationsMiddleware(),
      ...createNotesMiddleware(),
    ],
  );

  @override
  void initState() {
    super.initState();
    QuranThemeManager.instance.registerListener(onThemeChangedEvent);
    QuranThemeManager.instance.loadThemeAndNotifyListeners();
  }

  @override
  void dispose() {
    QuranThemeManager.instance.removeListeners();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: 'Quran',
        debugShowCheckedModeBanner: false,
        theme: QuranThemeManager.instance.theme,
        darkTheme: QuranThemeManager.instance.darkTheme,
        themeMode: QuranThemeManager.instance.currentAppThemeMode,
        home: widget.homeScreen,
      ),
    );
  }

  /// callback when theme changes
  void onThemeChangedEvent(String? _) async {
    // reload to apply the new theme
    setState(() {});
  }
}

/// load and save the quran words in memory
void _loadQuranWords() async {
  QuranSearch.globalQRWords = [];
  for (var i = 0; i < 114; i++) {
    List<List<NQWord>> words = await NobleQuran.getSurahWordByWord(i);
    for (List<NQWord> aya in words) {
      QuranSearch.globalQRWords.addAll(aya);
    }
  }
}
