import 'package:noble_quran/models/bookmark.dart';

abstract class QuranBookmarksInterface {
  Future<bool> save(int sura, int aya);

  Future<NQBookmark?> fetch();

  Future<bool> clear();
}
