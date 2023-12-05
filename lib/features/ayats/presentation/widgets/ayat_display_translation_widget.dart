import 'package:flutter/material.dart';
import 'package:noble_quran/enums/translations.dart';

import '../../../../misc/enums/quran_font_family_enum.dart';
import 'full_ayat_row_widget.dart';

class QuranAyatDisplayTranslationWidget extends StatelessWidget {
  final String translation;
  final NQTranslation translationType;

  const QuranAyatDisplayTranslationWidget({
    Key? key,
    required this.translation,
    required this.translationType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        children: [
          Expanded(
            child: Text(
              translationType.title,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
      QuranFullAyatRowWidget(
        text: translation,
        fontFamily: _translationFontFamily(translationType),
      ),
      const Divider(color: Colors.black12,),
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
