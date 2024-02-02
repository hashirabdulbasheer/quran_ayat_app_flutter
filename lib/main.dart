import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'features/auth/domain/auth_factory.dart';
import 'features/core/data/quran_firebase_engine.dart';
import 'features/core/domain/app_state/app_state.dart';
import 'features/home/presentation/quran_home_screen.dart';
import 'features/newAyat/presentation/quran_new_ayat_screen.dart';
import 'features/notes/domain/notes_manager.dart';
import 'features/settings/domain/settings_manager.dart';
import 'main_common.dart';
import 'misc/configs/remote_config_manager.dart';
import 'misc/enums/quran_feature_flag_enum.dart';
import 'misc/url/url_strategy.dart';

// TODO: Update before release
const String appVersion = "v3.0.0";

bool isChallengeBetaModeEnabled = RemoteConfigManager.instance
        .get(RemoteConfigFeatureFlagEnum.isChallengeScreenEnabled) &&
    QuranAuthFactory.engine.getUser() != null;

void main() async {
  usePathUrlStrategy();
  await QuranNotesManager.instance.offlineEngine.initialize();
  await QuranAuthFactory.engine.initialize(QuranFirebaseEngine.instance);
  FirebaseAnalytics.instance.logAppOpen();
  await RemoteConfigManager.instance.init();

  Widget homeScreen = const QuranNewAyatScreen();

  // enabling new challenges for logged in users only - for beta
  bool isChallengesEnabledInUserSettings =
      await QuranSettingsManager.instance.isChallengesFeatureEnabled();
  if (isChallengeBetaModeEnabled && isChallengesEnabledInUserSettings) {
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
