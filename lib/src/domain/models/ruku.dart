import 'package:ayat_app/src/domain/models/domain_models.dart';

class Ruku extends Equatable {
  final int id;
  final SurahIndex startIndex;
  final int numOfAya;

  const Ruku({
    required this.id,
    required this.startIndex,
    required this.numOfAya,
  });

  @override
  List<Object?> get props => [
        id,
        startIndex,
        numOfAya,
      ];
}
