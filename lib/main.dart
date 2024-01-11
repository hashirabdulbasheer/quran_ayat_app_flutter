import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'features/auth/domain/auth_factory.dart';
import 'features/core/domain/app_state/app_state.dart';
import 'features/home/presentation/quran_home_screen.dart';
import 'features/notes/data/hive_notes_impl.dart';
import 'main_common.dart';
import 'misc/configs/remote_config_manager.dart';
import 'misc/url/url_strategy.dart';

// TODO: Update before release
const String appVersion = "v2.8.8";

void main() async {
  usePathUrlStrategy();
  await QuranHiveNotesEngine.instance.initialize();
  await QuranAuthFactory.engine.initialize();
  FirebaseAnalytics.instance.logAppOpen();
  RemoteConfigManager.instance.init();

  runApp(MyApp(
    homeScreen: StoreBuilder<AppState>(
      rebuildOnChange: false,
      onInit: (store) => store.dispatch(AppStateInitializeAction()),
      builder: (
        BuildContext context,
        Store<AppState> store,
      ) =>
          const QuranHomeScreen(),
    ),
  ));
}
