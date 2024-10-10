import 'package:ayat_app/src/core/core.dart';
import 'package:ayat_app/src/data/models/local/data_local_models.dart';
import 'package:ayat_app/src/domain/models/domain_models.dart';

class NQayatlistToAyalistMapper implements Mapper<List<NQAyat>, List<QAya>> {
  @override
  List<QAya> mapFrom(List<NQAyat> from) {
    return from
        .map((e) => QAya(
              index: e.index,
              text: e.text,
            ))
        .toList();
  }
}
