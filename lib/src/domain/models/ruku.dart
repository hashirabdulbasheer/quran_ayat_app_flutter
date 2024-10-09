import 'package:ayat_app/src/domain/models/surah_index.dart';
import 'package:equatable/equatable.dart';

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
