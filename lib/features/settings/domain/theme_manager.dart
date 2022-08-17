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

  /// get the current theme
  Future<ThemeMode> currentThemeMode() async {
    if (isSystemDarkMode()) {
      // respect system dark mode
      return ThemeMode.dark;
    }
    final prefs = await SharedPreferences.getInstance();
    String? themeString = prefs.getString(themeId);
    if (themeString != null) {
      if (themeString == QuranAppTheme.dark.rawString()) {
        return ThemeMode.dark;
      }
    }
    return ThemeMode.light;
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
    _themeStream.add("quran_theme_changed_event");
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
}
