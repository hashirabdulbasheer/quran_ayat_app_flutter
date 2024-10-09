import 'package:ayat_app/src/core/usecases/usecases.dart';
import 'package:ayat_app/src/domain/repositories/settings_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

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
