import 'package:ayat_app/src/core/mapper/mapper.dart';
import 'package:ayat_app/src/domain/models/ruku.dart';
import 'package:ayat_app/src/domain/models/surah_index.dart';
import 'package:noble_quran/noble_quran.dart';

class NQRukuToRukuMapper implements Mapper<NQRuku, Ruku> {
  @override
  Ruku mapFrom(NQRuku from) {
    return Ruku(
      id: from.id,
      startIndex: SurahIndex(
        from.startIndexSura,
        from.startIndexAya,
      ),
      numOfAya: from.numOfAyas,
    );
  }
}
