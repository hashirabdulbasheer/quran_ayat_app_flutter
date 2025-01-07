import 'package:ayat_app/src/presentation/home/home.dart';

class TextRow extends StatelessWidget {
  final String text;
  final double textScaleFactor;
  final bool isSelected;

  const TextRow({
    super.key,
    required this.text,
    this.textScaleFactor = 1.0,
    this.isSelected = false,
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
              style: isSelected
                  ? const TextStyle(
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                    )
                  : const TextStyle(height: 1.5),
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
