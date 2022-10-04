import 'package:noble_quran/models/bookmark.dart';
import '../../../utils/prefs_utils.dart';
import '../domain/interfaces/bookmark_interface.dart';

class QuranLocalBookmarksEngine implements QuranBookmarksInterface {
  @override
  Future<bool> save(
    int sura,
    int aya,
  ) async {
    QuranPreferences.saveBookmark(
      sura,
      aya,
    );

    return true;
  }

  @override
  Future<NQBookmark?> fetch() async {
    return QuranPreferences.getBookmark();
  }

  @override
  Future<bool> clear() async {
    QuranPreferences.clearBookmark();

    return Future.value(true);
  }
}
