import 'package:quran_ayat/features/auth/domain/interfaces/quran_auth_interface.dart';

import 'features/bookmark/data/bookmarks_local_impl.dart';
import 'features/bookmark/data/firebase_bookmarks_impl.dart';
import 'features/bookmark/domain/bookmarks_manager.dart';
import 'models/qr_user_model.dart';
import 'quran_ayat_screen.dart';

class QuranComposer {
  static QuranAyatScreen composeAyatScreen({
    QuranAuthInterface? authEngine,
    int? suraIndex,
    int? ayaIndex,
  }) {
    QuranUser? user = authEngine?.getUser();
    if (user != null) {
      return QuranAyatScreen(
        surahIndex: suraIndex,
        ayaIndex: ayaIndex,
        bookmarksManager: QuranBookmarksManager(
          localEngine: QuranLocalBookmarksEngine(),
          remoteEngine: QuranFirebaseBookmarksEngine(
            userId: user.uid,
          ),
        ),
      );
    }

    return QuranAyatScreen(
      surahIndex: suraIndex,
      ayaIndex: ayaIndex,
      bookmarksManager: QuranBookmarksManager(
        localEngine: QuranLocalBookmarksEngine(),
      ),
    );
  }
}
