import 'package:ayat_app/src/core/mapper/mapper.dart';
import 'package:ayat_app/src/domain/models/qword.dart';
import 'package:noble_quran/noble_quran.dart';

class NQWordListListToQWordListListMapper
    implements Mapper<List<List<NQWord>>, List<List<QWord>>> {
  @override
  List<List<QWord>> mapFrom(List<List<NQWord>> from) {
    return from
        .map((e) => e
            .map((w) => QWord(
                  word: w.word,
                  tr: w.tr,
                  aya: w.aya,
                  sura: w.sura,
                  ar: w.ar,
                ))
            .toList())
        .toList();
  }
}
