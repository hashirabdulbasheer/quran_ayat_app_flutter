import 'package:ayat_app/src/core/core.dart';
import 'package:ayat_app/src/domain/models/domain_models.dart';

@injectable
class FetchWordTranslationStatusUseCase extends UseCaseSync<bool> {
  final SettingsRepository _repository;

  FetchWordTranslationStatusUseCase(this._repository);

  @override
  bool call() {
    return _repository.getIsWordByWordTranslationEnabled();
  }
}
