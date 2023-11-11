import 'package:flutter/material.dart';

import 'full_ayat_row_widget.dart';

class QuranAyatDisplayTransliterationWidget extends StatelessWidget {
  final String transliteration;

  const QuranAyatDisplayTransliterationWidget({
    Key? key,
    required this.transliteration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        QuranFullAyatRowWidget(
          text: transliteration,
        ),
      ],
    );
  }
}
