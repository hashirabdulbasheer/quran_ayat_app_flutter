export 'package:ayat_app/src/domain/mappers/localpage_to_page_mapper.dart';
export 'package:ayat_app/src/domain/mappers/localruku_to_ruku_mapper.dart';
export 'package:ayat_app/src/domain/mappers/nqayatlist_to_ayalist_mapper.dart';
export 'package:ayat_app/src/domain/mappers/nqwordlistlist_to_qwordlistlist_mapper.dart';
export 'package:ayat_app/src/domain/mappers/qtranslation_to_nqtranslation_mapper.dart';
export 'package:ayat_app/src/domain/mappers/nqtranslation_to_qtranslation_mapper.dart';

mixin Mapper<From, To> {
  To mapFrom(From from);
}