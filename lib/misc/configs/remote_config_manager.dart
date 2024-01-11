import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:quran_ayat/misc/constants/feature_flag_constants.dart';

class RemoteConfigManager {
  final _remoteConfig = FirebaseRemoteConfig.instance;

  static final RemoteConfigManager instance =
      RemoteConfigManager._privateConstructor();

  RemoteConfigManager._privateConstructor();

  // Remote Flags
  bool enableChallengesFeature = false;

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

  Future<void> _updateConfigs(RemoteConfigUpdate remoteConfigUpdate) async {
    await _remoteConfig.activate();
    enableChallengesFeature =
        _remoteConfig.getBool(kEnableChallengesFeatureKey);
  }

  Future<void> _setDefaultConfigs() async {
    return _remoteConfig
        .setDefaults(<String, dynamic>{kEnableChallengesFeatureKey: false});
  }
}
