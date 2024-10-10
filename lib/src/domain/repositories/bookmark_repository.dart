import 'package:ayat_app/src/domain/models/domain_models.dart';

abstract class BookmarkRepository {
  SurahIndex getBookmark();

  void saveBookmark(SurahIndex index);
}
