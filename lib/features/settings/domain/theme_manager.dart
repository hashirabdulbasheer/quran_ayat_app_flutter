import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../misc/design/design_system.dart';
import '../../../utils/color_utils.dart';

class QuranThemeManager {
  static final QuranThemeManager instance =
      QuranThemeManager._privateConstructor();

  ThemeData lightTheme = ThemeData(
    useMaterial3: false,
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
        statusBarColor: QuranDS.appBarBackground,
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

  ThemeMode _appTheme = ThemeMode.light;

  final StreamController<String> _themeStream = StreamController.broadcast();

  ThemeData? get theme => QuranThemeManager.instance.lightTheme;

  ThemeMode get currentAppThemeMode => _appTheme;

  QuranThemeManager._privateConstructor();

  /// loads the current theme and notify listeners about the theme change
  void loadThemeAndNotifyListeners() async {
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
}
