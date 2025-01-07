import 'package:ayat_app/src/core/core.dart';
import 'package:ayat_app/src/domain/models/domain_models.dart';

@injectable
class SaveDefaultTranslationUseCase extends UseCaseAsync<void, QTranslation> {
  final SettingsRepository _repository;

  SaveDefaultTranslationUseCase(this._repository);

  @override
  Future call(QTranslation params) async {
    return _repository.setDefaultTranslation(params);
  }
}
