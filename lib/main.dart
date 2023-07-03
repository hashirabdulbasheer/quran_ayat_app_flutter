import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'composer.dart';
import 'features/auth/domain/auth_factory.dart';
import 'features/core/domain/app_state/app_state.dart';
import 'features/notes/data/hive_notes_impl.dart';
import 'main_common.dart';
import 'misc/url/url_strategy.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:redux/redux.dart';

///
/// PRODUCTION
///

// TODO: Update before release
const String appVersion = "v2.6.4";

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

      loadQuranWords();
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
