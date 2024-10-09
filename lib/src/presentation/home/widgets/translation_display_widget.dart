import 'package:ayat_app/src/domain/enums/qtranslation_enum.dart';
import 'package:ayat_app/src/presentation/home/widgets/text_row_widget.dart';
import 'package:flutter/material.dart';

class TranslationDisplay extends StatelessWidget {
  final String translation;
  final QTranslation translationType;
  final double textScaleFactor;

  const TranslationDisplay({
    super.key,
    required this.translation,
    required this.translationType,
    this.textScaleFactor = 1.0,
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
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ],
        ),
        TextRow(
          text: translation,
          textScaleFactor: textScaleFactor,
        ),
      ],
    );
  }
}
