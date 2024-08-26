import 'package:flutter/material.dart';

import '../../../../misc/design/design_system.dart';
import 'full_ayat_row_widget.dart';

class QuranAyatDisplayTransliterationWidget extends StatelessWidget {
  final String transliteration;

  const QuranAyatDisplayTransliterationWidget({
    super.key,
    required this.transliteration,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Expanded(
              child: Text(
                "Transliteration",
                style: QuranDS.textTitleVerySmallLight,
              ),
            ),
          ],
        ),
        QuranFullAyatRowWidget(
          text: transliteration,
        ),
      ],
    );
  }
}
