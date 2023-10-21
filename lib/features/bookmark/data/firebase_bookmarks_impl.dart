import 'package:firebase_database/firebase_database.dart';
import 'package:noble_quran/models/bookmark.dart';

import '../domain/interfaces/bookmark_interface.dart';

class QuranFirebaseBookmarksEngine implements QuranBookmarksInterface {
  final String userId;

  QuranFirebaseBookmarksEngine({
    required this.userId,
  });

  @override
  Future<bool> save(
    int sura,
    int aya,
  ) async {
    if (userId != "") {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("bookmarks/$userId");
      await ref.set({
        "sura": sura,
        "aya": aya,
      });

      return true;
    }

    return false;
  }

  @override
  Future<NQBookmark?> fetch() async {
    if (userId != "") {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("bookmarks/$userId");
      final snapshot = await ref.get();
      dynamic resultList = snapshot.value;
      if (resultList != null) {
        int? sura = resultList["sura"] as int?;
        int? aya = resultList["aya"] as int?;
        if (sura != null && aya != null) {
          NQBookmark bookmark = NQBookmark(
            surah: sura,
            ayat: aya,
            word: 0,
            seconds: 0,
            pixels: 0,
          );

          return bookmark;
        }
      }
    }

    return null;
  }

  @override
  Future<bool> clear() {
    /// TODO: Implement clearing remote bookmark
    return Future.value(true);
  }
}
