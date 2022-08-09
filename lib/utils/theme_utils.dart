import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../misc/enums/quran_theme_enum.dart';

class QuranThemeManager {

  static ThemeData lightTheme = ThemeData(
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

  static ThemeData darkTheme = ThemeData(
      primarySwatch: Colors.grey,
      primaryColor: Colors.black,
      brightness: Brightness.dark,
      dividerColor: Colors.white60,
      appBarTheme:
          const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.dark),
      backgroundColor: const Color(0xFF212121),
      cardColor: Colors.black54,
      textTheme: const TextTheme(
          bodyText1: TextStyle(color: Colors.white),
          subtitle1: TextStyle(color: Colors.white60),
          subtitle2: TextStyle(color: Colors.white60, fontSize: 12)),
      cardTheme: const CardTheme(color: Colors.grey),
      buttonTheme: const ButtonThemeData(buttonColor: Colors.black38));

  /// get the current theme
  static Future<ThemeMode> currentThemeMode() async {
    if (QuranThemeManager.isSystemDarkMode()) {
      // respect system dark mode
      return ThemeMode.dark;
    }
    final prefs = await SharedPreferences.getInstance();
    String? themeString = prefs.getString("app_theme");
    if (themeString != null) {
      if (themeString == QuranAppTheme.dark.rawString()) {
        return ThemeMode.dark;
      }
    }
    return ThemeMode.light;
  }

  /// save theme
  static void saveTheme(QuranAppTheme theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("app_theme", theme.rawString());
  }

  static bool isSystemDarkMode() {
    final darkMode = WidgetsBinding.instance.window.platformBrightness;
    if (darkMode == Brightness.dark) {
      return true;
    } else {
      return false;
    }
  }
}
