import 'package:flutter/material.dart';

import '../features/bookmark/data/bookmarks_local_impl.dart';
import '../features/bookmark/data/firebase_bookmarks_impl.dart';
import '../features/bookmark/domain/bookmarks_manager.dart';
import '../quran_ayat_screen.dart';

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
        builder: (context) => QuranAyatScreen(
          surahIndex: surahIndex,
          ayaIndex: ayaIndex,
          bookmarksManager: QuranBookmarksManager(
            localEngine: QuranLocalBookmarksEngine(),
            remoteEngine: QuranFirebaseBookmarksEngine(),
          ),
        ),
      ),
    );
  }


}
