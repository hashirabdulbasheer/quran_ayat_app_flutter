import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../misc/design/design_system.dart';
import '../../../utils/color_utils.dart';

class QuranThemeManager {
  static final QuranThemeManager instance =
      QuranThemeManager._privateConstructor();

  ThemeData lightTheme = ThemeData(
    primarySwatch: MaterialColorGenerator.from(QuranDS.primaryColor),
    primaryColor: QuranDS.appBarBackground,
    scaffoldBackgroundColor: QuranDS.screenBackground,
    dividerColor: Colors.black26,
    shadowColor: QuranDS.appBarBackground,
    dialogBackgroundColor: QuranDS.screenBackground,
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: QuranDS.appBarBackground.withOpacity(0.5),
      cursorColor: QuranDS.appBarBackground,
      selectionHandleColor: QuranDS.appBarBackground,
    ),
    appBarTheme: const AppBarTheme(
      foregroundColor: Colors.white,
      color: QuranDS.appBarBackground,
      systemOverlayStyle: SystemUiOverlayStyle(
        systemNavigationBarColor: QuranDS.appBarBackground,
        statusBarIconBrightness: Brightness.light,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      titleMedium: TextStyle(color: Colors.black87),
      titleSmall: TextStyle(
        color: Colors.black54,
        fontSize: 12,
      ),
    ),
    fontFamily: "default",
    brightness: Brightness.light,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(QuranDS.appBarBackground),
        foregroundColor: MaterialStateProperty.all(Colors.white),
      ),
    ),
  );

  ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    fontFamily: "default",
    dividerColor: Colors.white60,
    appBarTheme: const AppBarTheme(
      color: Colors.black,
      systemOverlayStyle: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black,
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    ),
    backgroundColor: const Color(0xFF212121),
    cardColor: Colors.black54,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white),
      titleSmall: TextStyle(
        color: Colors.white60,
        fontSize: 12,
      ),
    ),
    cardTheme: const CardTheme(color: Colors.grey),
    buttonTheme: const ButtonThemeData(buttonColor: Colors.black38),
  );

  ThemeMode _appTheme = ThemeMode.light;

  final StreamController<String> _themeStream = StreamController.broadcast();

  ThemeData? get theme => _appTheme == ThemeMode.light
      ? QuranThemeManager.instance.lightTheme
      : QuranThemeManager.instance.darkTheme;

  ThemeMode get currentAppThemeMode => _appTheme;

  QuranThemeManager._privateConstructor();

  /// loads the current theme and notify listeners about the theme change
  void loadThemeAndNotifyListeners() async {
    /*
    if (isSystemDarkMode()) {
      // respect system dark mode
      _appTheme = ThemeMode.dark;
    } else {
      // load saved theme
      final prefs = await SharedPreferences.getInstance();
      String? themeString = prefs.getString(QuranSettingsConstants.themeId);
      if (themeString == null ||
          themeString == QuranAppTheme.light.rawString()) {
        _appTheme = ThemeMode.light;
      } else {
        _appTheme = ThemeMode.dark;
      }
    }
    */

    // forcing dark theme for now
    _appTheme = ThemeMode.light;

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
