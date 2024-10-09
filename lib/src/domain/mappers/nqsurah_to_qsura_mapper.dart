import 'package:ayat_app/src/core/mapper/mapper.dart';
import 'package:ayat_app/src/domain/models/qaya.dart';
import 'package:ayat_app/src/domain/models/qsura.dart';
import 'package:noble_quran/noble_quran.dart';

class NQSurahToQSuraMapper implements Mapper<NQSurah, QSura> {
  @override
  QSura mapFrom(NQSurah from) {
    return QSura(
        aya: from.aya.map((e) => QAya(index: e.index, text: e.text)).toList(),
        index: from.index,
        name: from.name);
  }
}
