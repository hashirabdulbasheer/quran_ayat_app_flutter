import 'package:ayat_app/src/core/usecases/usecases.dart';
import 'package:ayat_app/src/domain/models/ruku.dart';
import 'package:ayat_app/src/domain/models/surah_index.dart';
import 'package:ayat_app/src/domain/repositories/quran_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

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
