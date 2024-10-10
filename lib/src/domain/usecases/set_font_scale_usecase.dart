import 'package:ayat_app/src/core/core.dart';
import 'package:ayat_app/src/domain/models/domain_models.dart';

@injectable
class SetFontScaleUseCase extends UseCaseAsync<void, SetFontScaleParams> {
  final SettingsRepository _repository;

  SetFontScaleUseCase(this._repository);

  @override
  Future call(SetFontScaleParams params) async {
    return _repository.setFontScale(params.fontScale);
  }
}

class SetFontScaleParams extends Equatable {
  final double fontScale;

  const SetFontScaleParams({required this.fontScale});

  @override
  List<Object?> get props => [fontScale];
}
