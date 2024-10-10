import 'package:ayat_app/src/core/core.dart';
import 'package:ayat_app/src/domain/models/domain_models.dart';

@injectable
class FetchRukuIndexUseCase
    extends UseCaseSyncParams<Ruku?, FetchRukuIndexUseCaseParams> {
  final QuranRepository _repository;

  FetchRukuIndexUseCase(this._repository);

  @override
  Ruku? call(params) {
    return _repository.getRuku(params.index);
  }
}

class FetchRukuIndexUseCaseParams extends Equatable {
  final SurahIndex index;

  const FetchRukuIndexUseCaseParams({required this.index});

  @override
  List<Object?> get props => [index];
}
