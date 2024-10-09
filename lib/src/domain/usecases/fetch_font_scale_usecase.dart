import 'package:ayat_app/src/core/usecases/usecases.dart';
import 'package:ayat_app/src/domain/repositories/settings_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class FetchFontScaleUseCase extends UseCaseSync<double> {
  final SettingsRepository _repository;

  FetchFontScaleUseCase(this._repository);

  @override
  double call() {
    return _repository.getFontScale();
  }
}
