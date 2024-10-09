import 'package:ayat_app/src/core/usecases/usecases.dart';
import 'package:ayat_app/src/domain/models/surah_index.dart';
import 'package:ayat_app/src/domain/repositories/bookmark_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class FetchBookmarkUseCase extends UseCaseSync<SurahIndex> {
  final BookmarkRepository _repository;

  FetchBookmarkUseCase(this._repository);

  @override
  SurahIndex call() {
    return _repository.getBookmark();
  }
}
