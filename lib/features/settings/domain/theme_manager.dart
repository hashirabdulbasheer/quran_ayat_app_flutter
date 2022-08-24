import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../misc/enums/quran_theme_enum.dart';

class QuranThemeManager {
  QuranThemeManager._privateConstructor();

  static final QuranThemeManager instance =
      QuranThemeManager._privateConstructor();

  final String themeId = "quran_app_theme";
  final String transliterationId = "quran_app_transliteration";
  final String translationId = "quran_app_translation";
  final String audioControlsId = "quran_app_audio_controls";

  ThemeMode _appTheme = ThemeMode.light;

  ThemeData lightTheme = ThemeData(
      primarySwatch: Colors.deepPurple,
      dividerColor: Colors.black26,
      appBarTheme:
          const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.light),
      textTheme: const TextTheme(
          bodyText1: TextStyle(color: Colors.black),
          subtitle1: TextStyle(color: Colors.black87),
          subtitle2: TextStyle(color: Colors.black54, fontSize: 12)),
      fontFamily: "default",
      brightness: Brightness.light);

  ThemeData darkTheme = ThemeData(
      primarySwatch: Colors.grey,
      primaryColor: Colors.black,
      brightness: Brightness.dark,
      dividerColor: Colors.white60,
      appBarTheme: const AppBarTheme(
          color: Colors.black,
          systemOverlayStyle:
              SystemUiOverlayStyle(systemNavigationBarColor: Colors.black)),
      backgroundColor: const Color(0xFF212121),
      cardColor: Colors.black54,
      textTheme: const TextTheme(
          bodyText1: TextStyle(color: Colors.white),
          subtitle1: TextStyle(color: Colors.white60),
          subtitle2: TextStyle(color: Colors.white60, fontSize: 12)),
      cardTheme: const CardTheme(color: Colors.grey),
      buttonTheme: const ButtonThemeData(buttonColor: Colors.black38));

  final StreamController<String> _themeStream = StreamController.broadcast();

  ThemeData? get theme => _appTheme == ThemeMode.light
      ? QuranThemeManager.instance.lightTheme
      : QuranThemeManager.instance.darkTheme;

  ThemeMode get currentAppThemeMode => _appTheme;

  /// loads the current theme and notify listeners about the theme change
  void loadThemeAndNotifyListeners() async {
    if (isSystemDarkMode()) {
      // respect system dark mode
      _appTheme = ThemeMode.dark;
    } else {
      // load saved theme
      final prefs = await SharedPreferences.getInstance();
      String? themeString = prefs.getString(themeId);
      if (themeString == null ||
          themeString == QuranAppTheme.light.rawString()) {
        _appTheme = ThemeMode.light;
      } else {
        _appTheme = ThemeMode.dark;
      }
    }
    // inform all listeners
    _themeStream.add("quran_theme_changed_event");
  }

  /// register a listener to get theme update events
  void registerListener(void Function(String?) listener) {
    _themeStream.stream.listen(listener);
  }

  /// remove all theme update event listeners
  void removeListeners() {
    _themeStream.stream.listen(null);
  }

  /// called when theme changes
  void themeChanged() {
    loadThemeAndNotifyListeners();
  }

  /// is the current system in dark mode - respect that
  bool isSystemDarkMode() {
    final darkMode = WidgetsBinding.instance.window.platformBrightness;
    if (darkMode == Brightness.dark) {
      return true;
    } else {
      return false;
    }
  }

  /// is the current app theme in dark mode
  /// if system is dark mode then app theme respects that and will be dark mode
  bool isDarkMode() {
    if (_appTheme == ThemeMode.dark) {
      return true;
    }
    return false;
  }
}
