import 'package:equatable/equatable.dart';

class LocalPage extends Equatable {
  final int pgNo;
  final ({int sura, int aya}) firstAyaIndex;
  final int numOfAya;

  const LocalPage({
    required this.pgNo,
    required this.firstAyaIndex,
    required this.numOfAya,
  });

  @override
  List<Object?> get props => [
        pgNo,
        firstAyaIndex,
        numOfAya,
      ];
}
