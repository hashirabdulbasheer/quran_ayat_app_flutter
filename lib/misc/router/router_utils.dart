import 'package:flutter/material.dart';

import 'quran_router_enum.dart';

class QuranRouter {
  final BuildContext context;

  QuranRouter(this.context);

  static QuranRouter of(BuildContext context) {
    return QuranRouter(context);
  }

  Future<dynamic> _route(QuranScreen screen, {Object? arguments,}) async {
    return await Navigator.pushNamed(
      context,
      screen.rawString(),
      arguments: arguments,
    );
  }

  Future<void> routeToLogin() async {
    return await _route(QuranScreen.login);
  }

  Future<bool> routeToSignUp() async {
    return await _route(QuranScreen.signup) as bool;
  }
}
