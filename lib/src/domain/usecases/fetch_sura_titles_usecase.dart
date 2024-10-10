import 'package:ayat_app/src/core/core.dart';
import 'package:ayat_app/src/domain/models/domain_models.dart';
import 'package:dartz/dartz.dart';

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
