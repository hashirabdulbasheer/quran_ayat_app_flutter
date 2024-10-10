import 'package:ayat_app/src/core/core.dart';
import 'package:ayat_app/src/data/models/local/data_local_models.dart';
import 'package:ayat_app/src/domain/models/domain_models.dart';

class LocalPageToQPageMapper implements Mapper<LocalPage, QPage> {
  @override
  QPage mapFrom(LocalPage from) {
    return QPage(
      number: from.pgNo,
      firstAyaIndex:
          SurahIndex(from.firstAyaIndex.sura, from.firstAyaIndex.aya),
      numberOfAya: from.numOfAya,
    );
  }
}
