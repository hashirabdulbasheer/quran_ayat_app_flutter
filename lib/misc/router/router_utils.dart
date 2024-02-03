import 'package:flutter/material.dart';

import 'quran_router_enum.dart';

class QuranNavigator {
  final BuildContext context;

  QuranNavigator(this.context);

  static QuranNavigator of(BuildContext context) {
    return QuranNavigator(context);
  }

  Future<dynamic> _route(
    QuranScreen screen, {
    Object? arguments,
  }) async {
    return await Navigator.pushNamed(
      context,
      screen.rawString(),
      arguments: arguments,
    );
  }

  Future<void> routeToLogin() async {
    return await _route(QuranScreen.login);
  }

  Future<bool?> routeToSignUp() async {
    return await _route(QuranScreen.signup) as bool;
  }

  Future<void> routeToCreateNote({Object? arguments}) async {
    return await _route(
      QuranScreen.createNote,
      arguments: arguments,
    );
  }

  Future<void> routeToChallenge(Object? args) async {
    return await _route(
      QuranScreen.challenge,
      arguments: args,
    );
  }

  Future<void> routeToMySubmissions() async {
    return await _route(QuranScreen.mySubmissions);
  }

  Future<void> routeToCreateQuestions() async {
    return await _route(QuranScreen.createQuestion);
  }

  Future<void> routeToCreateChallenge(Object? args) async {
    return await _route(
      QuranScreen.createChallenge,
      arguments: args,
    );
  }

  Future<void> routeToConfirmation(Object? args) async {
    return await _route(
      QuranScreen.confirmation,
      arguments: args,
    );
  }

  Future<void> routeToEditAnswer(Object? args) async {
    return await _route(
      QuranScreen.editAnswer,
      arguments: args,
    );
  }

  Future<void> routeToTagResults(Object? args) async {
    return await _route(
      QuranScreen.tagResults,
      arguments: args,
    );
  }

  Future<void> routeToMessage(Object? args) async {
    return await _route(
      QuranScreen.message,
      arguments: args,
    );
  }

  Future<int?> routeToContext(Object? args) async {
    return await _route(
      QuranScreen.context,
      arguments: args,
    ) as int?;
  }

  Future<void> routeToViewTags(Object? args) async {
    return await _route(
      QuranScreen.viewTags,
      arguments: args,
    );
  }
}
