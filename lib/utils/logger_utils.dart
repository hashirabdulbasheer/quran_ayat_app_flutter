import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:redux/redux.dart';

/// enable/disable logging
class QuranLogger {
  static void log(String message) {
    if (kDebugMode) {
      print(message);
    }
  }

  static void logE(
    Object exception,
  ) {
    if (kDebugMode) {
      print(exception);
    }
  }

  static void logAnalytics(String event) {
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    analytics.logEvent(name: event);
  }
}

class LoggerMiddleware<State> implements MiddlewareClass<State> {
  @override
  void call(
    Store<State> store,
    dynamic action,
    NextDispatcher next,
  ) {
    next(action);

    QuranLogger.log("Logger: Action: $action, State: {${store.state}}");
  }
}
