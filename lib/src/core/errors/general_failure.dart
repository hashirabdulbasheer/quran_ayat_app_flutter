import 'package:ayat_app/src/core/errors/failure.dart';
import 'package:ayat_app/src/core/errors/general_exception.dart';

class GeneralFailure extends Failure {
  final String? message;

  GeneralFailure({this.message});

  factory GeneralFailure.fromGeneralException(GeneralException exception) {
    return GeneralFailure(message: exception.message);
  }

  @override
  List<Object?> get props => [message];
}
