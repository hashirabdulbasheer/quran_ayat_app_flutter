import 'package:ayat_app/src/core/core.dart';
import 'package:ayat_app/src/domain/models/domain_models.dart';
import 'package:dartz/dartz.dart';

@injectable
class FetchSuraUseCase extends UseCase<QPageData, FetchSuraUseCaseParams> {
  final QuranRepository _repository;

  FetchSuraUseCase(this._repository);

  @override
  ResultFuture<QPageData> call(params) async {
    try {
      final response = await _repository.getPageQuranData(
        pageNo: params.pageNo,
        translationType: params.translation,
      );
      return Right(response);
    } catch (e) {
      return Left(GeneralFailure.fromGeneralException(
        GeneralException(e.toString()),
      ));
    }
  }
}

class FetchSuraUseCaseParams extends Equatable {
  final int pageNo;
  final QTranslation translation;

  const FetchSuraUseCaseParams({
    required this.pageNo,
    required this.translation,
  });

  @override
  List<Object?> get props => [
        pageNo,
        translation,
      ];
}
