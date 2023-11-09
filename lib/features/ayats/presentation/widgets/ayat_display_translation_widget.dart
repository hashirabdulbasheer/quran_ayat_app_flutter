import 'package:flutter/material.dart';
import 'package:noble_quran/enums/translations.dart';
import 'package:noble_quran/models/surah.dart';
import 'package:noble_quran/models/surah_title.dart';
import 'package:noble_quran/noble_quran.dart';
import '../../../../misc/enums/quran_font_family_enum.dart';
import '../../../settings/domain/settings_manager.dart';
import 'full_ayat_row_widget.dart';

class QuranAyatDisplayTranslationWidget extends StatelessWidget {
  final NQSurah translation;
  final int ayaIndex;

  const QuranAyatDisplayTranslationWidget({
    Key? key,
    required this.translation,
    required this.ayaIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 20),
      QuranFullAyatRowWidget(
        translationString: translation.aya[ayaIndex].text,
        fontFamily: _translationFontFamily(NQTranslation.wahiduddinkhan),
        ayaIndex: ayaIndex,
      ),
    ]);
  }

  /// special font handling for translations
  String? _translationFontFamily(NQTranslation translation) {
    if (translation == NQTranslation.malayalam_karakunnu ||
        translation == NQTranslation.malayalam_abdulhameed) {
      return QuranFontFamily.malayalam.rawString;
    }

    return null;
  }
}
