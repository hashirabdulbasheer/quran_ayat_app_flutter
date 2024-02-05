import 'package:flutter/material.dart';

import '../enums/quran_font_family_enum.dart';

/// Design System
class QuranDS {
  /// TextStyle
  static const TextStyle textTitleSmall = TextStyle(
    fontSize: 12,
    color: QuranDS.textColor,
  );
  static const TextStyle textTitleLarge = TextStyle(
    fontSize: 16,
    color: QuranDS.textColor,
  );
  static const TextStyle textTitleSmallLight = TextStyle(
    fontSize: 12,
    color: QuranDS.lightTextColor,
  );
  static const TextStyle textTitleVerySmallLight = TextStyle(
    fontSize: 10,
    color: QuranDS.lightTextColor,
  );
  static const TextStyle textTitleMediumLight = TextStyle(
    fontSize: 14,
    color: QuranDS.lightTextColor,
  );
  static const TextStyle textTitleMediumLightSmallLineSpacing = TextStyle(
    fontSize: 14,
    height: 1.5,
    fontWeight: FontWeight.normal,
    color: QuranDS.lightTextColor,
  );
  static const TextStyle textTitleMediumItalic = TextStyle(
    fontSize: 14,
    fontStyle: FontStyle.italic,
  );
  static const TextStyle textTitleLargeDarkSmallLineSpacing = TextStyle(
    fontSize: 16,
    height: 1.5,
    color: QuranDS.veryDarkTextColor,
  );
  static TextStyle textTitleLargeDarkSmallLineSpacingMalayalamFont = TextStyle(
    fontSize: 16,
    height: 1.5,
    fontFamily: QuranFontFamily.malayalam.rawString,
    color: QuranDS.veryDarkTextColor,
  );
  static const TextStyle textTitleLargeBold = TextStyle(
    fontSize: 16,
    color: QuranDS.textColor,
    fontWeight: FontWeight.bold,
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
  static const Icon thumbsUpIconSelectedLarge = Icon(
    Icons.thumb_up,
    color: QuranDS.primaryColor,
    size: 24.0,
  );
  static const Icon thumbsUpIconUnSelectedLarge = Icon(
    Icons.thumb_up_alt_outlined,
    color: QuranDS.primaryColor,
    size: 24.0,
  );
  static const Icon thumbsUpIconDisabledLarge = Icon(
    Icons.thumb_up_alt_outlined,
    color: QuranDS.disabledIconColor,
    size: 24.0,
  );
  static const Icon readIconColoured = Icon(
    Icons.menu_book_rounded,
    color: QuranDS.primaryColor,
  );
  static const Icon editIconColoured = Icon(
    Icons.edit_note,
    color: QuranDS.primaryColor,
  );
  static const Icon editIconDisabled = Icon(
    Icons.edit_note,
    color: QuranDS.disabledIconColor,
  );
  static const Icon reportProblemDisabled = Icon(
    Icons.report_problem_outlined,
    color: QuranDS.disabledIconColor,
  );
  static const Icon reportProblemColoured = Icon(
    Icons.report_problem_outlined,
    color: QuranDS.primaryColor,
  );

  /// Decorations
  static const BoxDecoration boxDecorationVeryLightBorder = BoxDecoration(
    border:
        Border.fromBorderSide(BorderSide(color: QuranDS.veryLightTextColor)),
    color: QuranDS.veryLightTextColor,
    borderRadius: BorderRadius.all(Radius.circular(5)),
  );

  /// Color
  static const Color screenBackground = Color(0xFFEFFFE2);
  static const Color appBarBackground = Color(0xFF1E5A06);
  static const Color primaryColor = appBarBackground;
  static const Color veryLightColor = Colors.black12;
  static const Color textColor = Colors.black;
  static const Color lightTextColor = Colors.black54;
  static const Color veryLightTextColor = Colors.black12;
  static const Color veryDarkTextColor = Colors.black87;
  static const Color disabledIconColor = Colors.black12;
}
