import 'package:ayat_app/src/core/mapper/mapper.dart';
import 'package:ayat_app/src/data/models/local_page.dart';
import 'package:ayat_app/src/domain/models/page.dart';
import 'package:ayat_app/src/domain/models/surah_index.dart';

class LocalPageToQPageMapper implements Mapper<LocalPage, QPage> {
  @override
  QPage mapFrom(LocalPage from) {
    return QPage(
      number: from.pgNo,
      firstAyaIndex: SurahIndex(from.firstAyaIndex.sura, from.firstAyaIndex.aya),
      numberOfAya: from.numOfAya,
    );
  }
}
