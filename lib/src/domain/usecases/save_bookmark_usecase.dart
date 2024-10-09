import 'package:ayat_app/src/core/usecases/usecases.dart';
import 'package:ayat_app/src/domain/models/surah_index.dart';
import 'package:ayat_app/src/domain/repositories/bookmark_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveBookmarkUseCase extends UseCaseAsync<void, SurahIndex> {
  final BookmarkRepository _repository;

  SaveBookmarkUseCase(this._repository);

  @override
  Future call(SurahIndex params) async {
    return _repository.saveBookmark(params);
  }
}
