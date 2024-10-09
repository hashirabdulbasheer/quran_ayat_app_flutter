import 'package:ayat_app/src/core/mapper/mapper.dart';
import 'package:ayat_app/src/domain/models/qaya.dart';
import 'package:noble_quran/noble_quran.dart';

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
