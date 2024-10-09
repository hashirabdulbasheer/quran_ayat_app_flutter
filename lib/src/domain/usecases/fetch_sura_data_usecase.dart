import 'package:ayat_app/src/core/errors/general_exception.dart';
import 'package:ayat_app/src/core/errors/general_failure.dart';
import 'package:ayat_app/src/core/usecases/usecases.dart';
import 'package:ayat_app/src/domain/enums/qtranslation_enum.dart';
import 'package:ayat_app/src/domain/models/qdata.dart';
import 'package:ayat_app/src/domain/repositories/quran_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

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
        e as GeneralException,
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
