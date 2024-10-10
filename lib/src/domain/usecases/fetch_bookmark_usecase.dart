import 'package:ayat_app/src/core/core.dart';
import 'package:ayat_app/src/domain/models/domain_models.dart';

@injectable
class FetchBookmarkUseCase extends UseCaseSync<SurahIndex> {
  final BookmarkRepository _repository;

  FetchBookmarkUseCase(this._repository);

  @override
  SurahIndex call() {
    return _repository.getBookmark();
  }
}
