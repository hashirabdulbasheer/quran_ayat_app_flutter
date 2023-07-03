import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'composer.dart';
import 'features/auth/domain/auth_factory.dart';
import 'features/core/domain/app_state/app_state.dart';
import 'features/core/domain/env.dart';
import 'features/notes/data/hive_notes_impl.dart';
import 'main_common.dart';
import 'misc/url/url_strategy.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:redux/redux.dart';

///
/// DEV
///
void main() async {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await QuranHiveNotesEngine.instance.initialize();
  await QuranAuthFactory.engine.initialize();
  FirebaseAnalytics.instance.logAppOpen();

  BuildEnvironment.init(
    flavor: BuildFlavor.development,
    baseUrl: '',
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
}
