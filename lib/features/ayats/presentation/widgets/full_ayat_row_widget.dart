import 'package:flutter/material.dart';

import '../../../../utils/utils.dart';
import 'font_scaler_widget.dart';

class QuranFullAyatRowWidget extends StatelessWidget {
  final String text;
  final String? fontFamily;

  const QuranFullAyatRowWidget({
    Key? key,
    required this.text,
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
      textDirection: QuranUtils.isArabic(text)
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Row(
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Text(
                _stripHtmlIfNeeded(text),
                textAlign: TextAlign.start,
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
