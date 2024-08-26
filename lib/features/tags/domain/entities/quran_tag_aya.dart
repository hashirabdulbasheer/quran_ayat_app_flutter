import 'package:equatable/equatable.dart';
import 'package:quran_ayat/features/newAyat/data/surah_index.dart';

class QuranTagAya extends Equatable {
  final SurahIndex index;

  const QuranTagAya({
    required this.index,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "sura": index.sura,
      "aya": index.aya,
    };
  }

  @override
  String toString() {
    return 'QuranTagAya{suraIndex: ${index.human.sura}, ayaIndex: ${index.human.aya}';
  }

  @override
  List<Object> get props => [
        index,
      ];
}
