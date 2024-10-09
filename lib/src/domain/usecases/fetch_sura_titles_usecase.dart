import 'package:ayat_app/src/core/errors/general_exception.dart';
import 'package:ayat_app/src/core/errors/general_failure.dart';
import 'package:ayat_app/src/core/usecases/usecases.dart';
import 'package:ayat_app/src/domain/models/sura_title.dart';
import 'package:ayat_app/src/domain/repositories/quran_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class FetchSuraTitlesUseCase extends UseCase<List<SuraTitle>, NoParams> {
  final QuranRepository _repository;

  FetchSuraTitlesUseCase(this._repository);

  @override
  ResultFuture<List<SuraTitle>> call(params) async {
    try {
      final response = await _repository.getSuraTitles();
      return Right(response);
    } catch (e) {
      return Left(GeneralFailure.fromGeneralException(
        e as GeneralException,
      ));
    }
  }
}
