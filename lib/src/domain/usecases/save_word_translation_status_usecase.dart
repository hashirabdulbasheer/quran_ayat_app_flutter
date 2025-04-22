import 'package:ayat_app/src/core/core.dart';
import 'package:ayat_app/src/domain/models/domain_models.dart';

@injectable
class SaveWordTranslationStatusUseCase
    extends UseCaseAsync<void, SaveWordTranslationStatusParams> {
  final SettingsRepository _repository;

  SaveWordTranslationStatusUseCase(this._repository);

  @override
  Future call(SaveWordTranslationStatusParams params) async {
    return _repository.setIsWordByWordTranslationEnabled(params.isEnabled);
  }
}

class SaveWordTranslationStatusParams extends Equatable {
  final bool isEnabled;

  const SaveWordTranslationStatusParams({required this.isEnabled});

  @override
  List<Object?> get props => [isEnabled];
}
