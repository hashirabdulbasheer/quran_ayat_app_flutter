import 'package:flutter/material.dart';
import 'package:quran_ayat/composer.dart';
import 'package:quran_ayat/features/tags/domain/entities/quran_master_tag.dart';
import 'package:quran_ayat/features/tags/presentation/quran_results_screen.dart';

import '../features/tags/domain/entities/quran_index.dart';

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

  static void navigationToResultsScreen(
    BuildContext context,
    QuranMasterTag tag,
  ) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => QuranResultsScreen(tag: tag),
      ),
    );
  }
}
