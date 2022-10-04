import 'package:flutter/material.dart';
import 'package:quran_ayat/composer.dart';

class QuranNavigator {
  /// navigate to ayat screen
  static void navigateToAyatScreen(
    BuildContext context, {
    int? surahIndex,
    int? ayaIndex,
  }) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => QuranComposer.composeAyatScreen(
          suraIndex: surahIndex,
          ayaIndex: ayaIndex,
        ),
      ),
    );
  }
}
