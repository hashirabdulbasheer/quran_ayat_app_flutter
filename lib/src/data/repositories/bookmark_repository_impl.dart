import 'package:ayat_app/src/data/models/local/data_local_models.dart';
import 'package:ayat_app/src/domain/models/domain_models.dart';

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
