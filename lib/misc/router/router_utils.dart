import 'package:flutter/material.dart';

class QuranRouter {
  final BuildContext context;

  QuranRouter(this.context);

  static QuranRouter of(BuildContext context) {
    return QuranRouter(context);
  }

  Future<void> routeToLogin() async {
    await Navigator.pushNamed(
      context,
      "/login",
    );

    return;
  }
}
