import 'package:flutter/material.dart';

import '../features/tags/domain/entities/quran_tag.dart';
import '../features/tags/presentation/quran_results_screen.dart';


class QuranNavigator {
  /// navigate to ayat screen
  static void navigateToAyatScreen(
    BuildContext context, {
    int? surahIndex,
    int? ayaIndex,
  }) {
    // FIXME: Fix navigation to ayat screen
    // Navigator.push<void>(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => QuranComposer.composeAyatScreen(
    //       suraIndex: surahIndex,
    //       ayaIndex: ayaIndex,
    //     ),
    //   ),
    // );
  }

  static void navigationToResultsScreen(
    BuildContext context,
    QuranTag tag,
  ) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => QuranResultsScreen(tag: tag),
      ),
    );
  }
}
