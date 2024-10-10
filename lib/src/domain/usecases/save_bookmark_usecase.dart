import 'package:ayat_app/src/core/core.dart';
import 'package:ayat_app/src/domain/models/domain_models.dart';

@injectable
class SaveBookmarkUseCase extends UseCaseAsync<void, SurahIndex> {
  final BookmarkRepository _repository;

  SaveBookmarkUseCase(this._repository);

  @override
  Future call(SurahIndex params) async {
    return _repository.saveBookmark(params);
  }
}
