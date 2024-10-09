import 'package:ayat_app/src/domain/models/surah_index.dart';

abstract class BookmarkRepository {
  SurahIndex getBookmark();

  void saveBookmark(SurahIndex index);
}