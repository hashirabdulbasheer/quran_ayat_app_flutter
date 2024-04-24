import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

import 'features/auth/domain/auth_factory.dart';
import 'features/core/data/quran_firebase_engine.dart';
import 'features/notes/domain/notes_manager.dart';
import 'features/settings/domain/settings_manager.dart';
import 'main_common.dart';
import 'misc/configs/remote_config_manager.dart';
import 'misc/enums/quran_feature_flag_enum.dart';
import 'misc/url/url_strategy.dart';

// TODO: Update before release
const String appVersion = "v3.1.3";

bool isChallengeBetaModeEnabled = RemoteConfigManager.instance
        .get(RemoteConfigFeatureFlagEnum.isChallengeScreenEnabled);

void main() async {
  usePathUrlStrategy();
  await QuranNotesManager.instance.offlineEngine.initialize();
  await QuranAuthFactory.engine.initialize(QuranFirebaseEngine.instance);
  FirebaseAnalytics.instance.logAppOpen();
  await RemoteConfigManager.instance.init();

  bool isChallengeEnabled = false;

  // enabling new challenges for logged in users only - for beta
  bool isChallengesEnabledInUserSettings =
      await QuranSettingsManager.instance.isChallengesFeatureEnabled();
  if (isChallengeBetaModeEnabled && isChallengesEnabledInUserSettings) {
    isChallengeEnabled = true;
  }

  runApp(MyApp(isChallengeEnabled: isChallengeEnabled));
}
