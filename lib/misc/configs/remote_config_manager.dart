import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

import '../constants/feature_flag_constants.dart';
import '../enums/quran_feature_flag_enum.dart';

class RemoteConfigManager {
  final _remoteConfig = FirebaseRemoteConfig.instance;

  static final RemoteConfigManager instance =
      RemoteConfigManager._privateConstructor();

  RemoteConfigManager._privateConstructor() {
    init();
  }

  // Remote Flags
  bool isChallengesFeatureEnabled = false;

  Future<void> init() async {
    try {
      if (!kIsWeb) {
        _remoteConfig.onConfigUpdated.listen(
          _updateConfigs,
          onError: (Object error) {},
        );
      }
      await _remoteConfig.ensureInitialized();
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(minutes: 5),
      ));
      await _setDefaultConfigs();
      await _remoteConfig.fetchAndActivate();
    } finally {
      await _updateConfigs(RemoteConfigUpdate({}));
    }
  }

  bool get(RemoteConfigFeatureFlagEnum flag) {
    switch (flag) {
      case RemoteConfigFeatureFlagEnum.isChallengeScreenEnabled:
        return isChallengesFeatureEnabled;
    }
  }

  Future<void> _updateConfigs(RemoteConfigUpdate remoteConfigUpdate) async {
    await _remoteConfig.activate();
    isChallengesFeatureEnabled =
        _remoteConfig.getBool(kEnableChallengesFeatureKey);
  }

  Future<void> _setDefaultConfigs() async {
    return _remoteConfig.setDefaults(<String, dynamic>{});
  }
}
