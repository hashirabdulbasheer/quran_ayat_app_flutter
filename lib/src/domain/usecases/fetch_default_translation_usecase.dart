import 'package:ayat_app/src/core/core.dart';
import 'package:ayat_app/src/domain/models/domain_models.dart';

@injectable
class FetchDefaultTranslationUseCase extends UseCaseSync<QTranslation> {
  final SettingsRepository _repository;

  FetchDefaultTranslationUseCase(this._repository);

  @override
  QTranslation call() {
    return _repository.getDefaultTranslation();
  }
}
