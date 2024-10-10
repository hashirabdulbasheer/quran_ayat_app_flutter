import 'package:ayat_app/src/core/core.dart';
import 'package:ayat_app/src/data/models/local/data_local_models.dart';
import 'package:ayat_app/src/domain/models/domain_models.dart';

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
