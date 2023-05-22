import 'package:flutter/foundation.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

/// enable/disable logging
class QuranLogger {
  static void log(String message) {
    if (kDebugMode) {
      print(message);
    }
  }

  static void logE(Object exception) {
    if (kDebugMode) {
      print(exception);
    }
  }

  static void logAnalytics(String event) {
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    analytics.logEvent(name: event);
  }
}
