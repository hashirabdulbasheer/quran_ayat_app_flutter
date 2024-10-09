
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: false,
    primarySwatch: MaterialColorGenerator.from(QuranDS.primaryColor),
    primaryColor: QuranDS.appBarBackground,
    scaffoldBackgroundColor: QuranDS.screenBackground,
    dividerColor: Colors.black26,
    shadowColor: Colors.black26,
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
        backgroundColor: WidgetStateProperty.all(QuranDS.appBarBackground),
        foregroundColor: WidgetStateProperty.all(Colors.white),
      ),
    ),
  );
}

class MaterialColorGenerator {
  static MaterialColor from(Color color) {
    return MaterialColor(
      color.value,
      <int, Color>{
        50: color.withOpacity(0.1),
        100: color.withOpacity(0.2),
        200: color.withOpacity(0.3),
        300: color.withOpacity(0.4),
        400: color.withOpacity(0.5),
        500: color.withOpacity(0.6),
        600: color.withOpacity(0.7),
        700: color.withOpacity(0.8),
        800: color.withOpacity(0.9),
        900: color.withOpacity(1.0),
      },
    );
  }
}

class QuranDS {
  /// Color
  static const Color screenBackgroundLittleDarker = Color(0xFFF3F6EE);
  static const Color screenBackground = Color(0xFFF9FAF8);
  static const Color appBarBackground = Color(0xFF297863);
  static const Color primaryColor = appBarBackground;
  static const Color veryLightColor = Colors.black12;
  static const Color veryVeryLightColor = Colors.white10;
  static const Color textColor = Colors.black;
  static const Color lightTextColor = Colors.black54;
  static const Color veryLightTextColor = Colors.black12;
  static const Color veryDarkTextColor = Colors.black87;
  static const Color disabledIconColor = Colors.black12;
}