import 'package:ayat_app/src/presentation/home/home.dart';

class TranslationDisplay extends StatelessWidget {
  final String translation;
  final QTranslation translationType;
  final double textScaleFactor;
  final bool isSelected;

  const TranslationDisplay({
    super.key,
    required this.translation,
    required this.translationType,
    this.textScaleFactor = 1.0,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = isSelected
        ? theme.textTheme.labelSmall
            ?.copyWith(fontWeight: FontWeight.bold)
        : theme.textTheme.labelSmall;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                translationType.title,
                style: style,
              ),
            ),
          ],
        ),
        TextRow(
          text: translation,
          textScaleFactor: textScaleFactor,
          isSelected: isSelected,
        ),
      ],
    );
  }
}
