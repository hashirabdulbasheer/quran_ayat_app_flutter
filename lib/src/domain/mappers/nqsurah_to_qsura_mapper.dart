import 'package:ayat_app/src/core/core.dart';
import 'package:ayat_app/src/data/models/local/data_local_models.dart';
import 'package:ayat_app/src/domain/models/domain_models.dart';

class NQSurahToQSuraMapper implements Mapper<NQSurah, QSura> {
  @override
  QSura mapFrom(NQSurah from) {
    return QSura(
        aya: from.aya.map((e) => QAya(index: e.index, text: e.text)).toList(),
        index: from.index,
        name: from.name);
  }
}
