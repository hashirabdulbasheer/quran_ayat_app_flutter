import 'package:equatable/equatable.dart';

class QuranTagAya extends Equatable {
  final int suraIndex;
  final int ayaIndex;

  const QuranTagAya({
    required this.suraIndex,
    required this.ayaIndex,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "sura": suraIndex,
      "aya": ayaIndex,
    };
  }

  @override
  String toString() {
    return 'QuranTagAya{suraIndex: $suraIndex, ayaIndex: $ayaIndex}';
  }

  @override
  List<Object> get props => [
        suraIndex,
        ayaIndex,
      ];
}
