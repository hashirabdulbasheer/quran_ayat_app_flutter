import 'package:flutter/material.dart';

class TextRow extends StatelessWidget {
  final String text;
  final double textScaleFactor;

  const TextRow({
    super.key,
    required this.text,
    this.textScaleFactor = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              15,
              5,
              15,
              5,
            ),
            child: SelectableText(
              _stripHtmlIfNeeded(text),
              textAlign: TextAlign.start,
              style: const TextStyle(height: 1.5),
              textScaler: TextScaler.linear(textScaleFactor),
            ),
          ),
        ),
      ],
    );
  }

  static String _stripHtmlIfNeeded(String text) {
    return text.replaceAll(
      RegExp(r'<[^>]*>|&[^;]+;'),
      '',
    );
  }
}
