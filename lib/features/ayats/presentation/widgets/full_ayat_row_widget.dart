import 'package:flutter/material.dart';

import '../../../../utils/utils.dart';
import 'font_scaler_widget.dart';

class QuranFullAyatRowWidget extends StatelessWidget {
  final String translationString;
  final String? fontFamily;

  const QuranFullAyatRowWidget({
    Key? key,
    required this.translationString,
    this.fontFamily,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QuranFontScalerWidget(body: _body);
  }

  Widget _body(
    BuildContext context,
    double fontScale,
  ) {
    return Directionality(
      textDirection: QuranUtils.isArabic(translationString)
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Row(
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                _stripHtmlIfNeeded(translationString),
                textAlign: QuranUtils.isArabic(translationString)
                    ? TextAlign.end
                    : TextAlign.start,
                textScaleFactor: fontScale,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontFamily: fontFamily,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _stripHtmlIfNeeded(String text) {
    return text.replaceAll(
      RegExp(r'<[^>]*>|&[^;]+;'),
      '',
    );
  }
}
