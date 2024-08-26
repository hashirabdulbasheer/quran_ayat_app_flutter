import 'package:flutter/material.dart';
import 'package:noble_quran/enums/translations.dart';

import '../../../../misc/design/design_system.dart';
import '../../../../misc/enums/quran_font_family_enum.dart';
import 'full_ayat_row_widget.dart';

class QuranAyatDisplayTranslationWidget extends StatelessWidget {
  final String translation;
  final NQTranslation translationType;

  const QuranAyatDisplayTranslationWidget({
    super.key,
    required this.translation,
    required this.translationType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                translationType.title,
                style: QuranDS.textTitleVerySmallLight,
              ),
            ),
          ],
        ),
        QuranFullAyatRowWidget(
          text: translation,
          fontFamily: _translationFontFamily(translationType),
        ),
        const Divider(color: QuranDS.veryLightColor),
      ],
    );
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
