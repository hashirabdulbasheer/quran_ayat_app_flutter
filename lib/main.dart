import 'package:flutter/material.dart';

import 'features/auth/domain/auth_factory.dart';
import 'features/core/data/quran_firebase_engine.dart';
import 'main_common.dart';
import 'misc/url/url_strategy.dart';

// TODO: Update before release
const String appVersion = "v3.1.6";

void main() async {
  usePathUrlStrategy();
  await QuranAuthFactory.engine.initialize(QuranFirebaseEngine.instance);
  runApp(const MyApp());
}
