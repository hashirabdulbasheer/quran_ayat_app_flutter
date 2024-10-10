import 'package:ayat_app/src/core/core.dart';
import 'package:ayat_app/src/domain/models/domain_models.dart';

@injectable
class FetchFontScaleUseCase extends UseCaseSync<double> {
  final SettingsRepository _repository;

  FetchFontScaleUseCase(this._repository);

  @override
  double call() {
    return _repository.getFontScale();
  }
}
