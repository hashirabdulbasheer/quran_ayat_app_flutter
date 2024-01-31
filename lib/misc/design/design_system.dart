import 'package:flutter/material.dart';

/// Design System
class QuranDS {
  /// TextSTyle
  static const TextStyle textTitleSmall = TextStyle(
    fontSize: 12,
    color: QuranDS.textColor,
  );
  static const TextStyle textTitleSmallLight = TextStyle(
    fontSize: 12,
    color: QuranDS.lightTextColor,
  );

  /// ButtonStyle
  static ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: QuranDS.veryLightTextColor,
    shadowColor: Colors.transparent,
    textStyle: const TextStyle(color: QuranDS.primaryColor),
  );

  /// Icons
  static const Icon removeIconLightSmall = Icon(
    Icons.remove,
    size: 15,
    color: QuranDS.lightTextColor,
  );
  static const Icon refreshIconLightSmall = Icon(
    Icons.refresh,
    size: 15,
    color: QuranDS.lightTextColor,
  );
  static const Icon addIconLightSmall = Icon(
    Icons.add,
    size: 15,
    color: QuranDS.lightTextColor,
  );
  static const Icon listIconLightSmall = Icon(
    Icons.list_alt,
    size: 15,
    color: QuranDS.lightTextColor,
  );
  static const Icon closeIconVerySmall = Icon(
    Icons.close,
    size: 12,
    color: QuranDS.textColor,
  );

  /// Color
  static const Color primaryColor = Colors.blueGrey;
  static const Color textColor = Colors.black;
  static const Color lightTextColor = Colors.black54;
  static const Color veryLightTextColor = Colors.black12;
}
