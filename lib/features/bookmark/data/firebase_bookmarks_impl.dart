import 'package:firebase_database/firebase_database.dart';
import 'package:noble_quran/models/bookmark.dart';
import '../../../models/qr_user_model.dart';
import '../../auth/domain/auth_factory.dart';
import '../domain/interfaces/bookmark_interface.dart';

class QuranFirebaseBookmarksEngine implements QuranBookmarksInterface {
  QuranFirebaseBookmarksEngine._privateConstructor();

  static final QuranFirebaseBookmarksEngine instance =
      QuranFirebaseBookmarksEngine._privateConstructor();

  @override
  Future<bool> save(int sura, int aya) async {
    QuranUser? user = QuranAuthFactory.engine.getUser();
    if (user != null) {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("bookmarks/${user.uid}");
      await ref.set({"sura": sura, "aya": aya});
      return true;
    }
    return false;
  }

  @override
  Future<NQBookmark?> fetch() async {
    QuranUser? user = QuranAuthFactory.engine.getUser();
    if (user != null) {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("bookmarks/${user.uid}");
      final snapshot = await ref.get();
      Map<String, dynamic>? resultList =
          snapshot.value as Map<String, dynamic>?;
      if (resultList != null) {
        int? sura = resultList["sura"];
        int? aya = resultList["aya"];
        if (sura != null && aya != null) {
          NQBookmark bookmark = NQBookmark(
              surah: sura, ayat: aya, word: 0, seconds: 0, pixels: 0);
          return bookmark;
        }
      }
    }
    return null;
  }

  @override
  Future<bool> clear() {
    return Future.value(true);
  }
}
