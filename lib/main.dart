import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'features/auth/domain/auth_factory.dart';
import 'features/core/domain/app_state/app_state.dart';
import 'features/home/presentation/quran_home_screen.dart';
import 'features/newAyat/presentation/quran_new_ayat_screen.dart';
import 'features/notes/data/hive_notes_impl.dart';
import 'main_common.dart';
import 'misc/configs/remote_config_manager.dart';
import 'misc/enums/quran_feature_flag_enum.dart';
import 'misc/url/url_strategy.dart';
import 'models/qr_user_model.dart';

// TODO: Update before release
const String appVersion = "v2.8.8";

void main() async {
  usePathUrlStrategy();
  await QuranHiveNotesEngine.instance.initialize();
  await QuranAuthFactory.engine.initialize();
  FirebaseAnalytics.instance.logAppOpen();
  await RemoteConfigManager.instance.init();

  QuranUser? user = QuranAuthFactory.engine.getUser();
  Widget homeScreen = const QuranNewAyatScreen();
  // enabling new challenges for logged in users only - for beta
  if (RemoteConfigManager.instance
          .get(RemoteConfigFeatureFlagEnum.isChallengeScreenEnabled) &&
      user != null) {
    homeScreen = const QuranHomeScreen();
  }

  runApp(MyApp(
    homeScreen: StoreBuilder<AppState>(
      rebuildOnChange: false,
      onInit: (store) => store.dispatch(AppStateInitializeAction()),
      builder: (
        BuildContext context,
        Store<AppState> store,
      ) =>
          homeScreen,
    ),
  ));
}
