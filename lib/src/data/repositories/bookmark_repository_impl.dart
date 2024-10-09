import 'package:ayat_app/src/data/local/bookmark_local_data_source.dart';
import 'package:ayat_app/src/domain/models/surah_index.dart';
import 'package:ayat_app/src/domain/repositories/bookmark_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:noble_quran/noble_quran.dart';

@LazySingleton(as: BookmarkRepository)
class BookmarkRepositoryImpl extends BookmarkRepository {
  BookmarkDataSource dataSource;

  BookmarkRepositoryImpl({required this.dataSource});

  @override
  SurahIndex getBookmark() {
    NQBookmark? nqBookmark = dataSource.getBookmark();
    return nqBookmark != null
        ? SurahIndex(nqBookmark.surah, nqBookmark.ayat)
        : SurahIndex.defaultIndex;
  }

  @override
  void saveBookmark(SurahIndex index) {
    dataSource.saveBookmark(index.sura, index.aya);
  }
}
