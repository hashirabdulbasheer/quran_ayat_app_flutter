import 'package:ayat_app/src/presentation/home/home.dart';

class ArabicText extends StatelessWidget {
  final String text;
  final double textScaleFactor;

  const ArabicText({
    super.key,
    required this.text,
    this.textScaleFactor = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      softWrap: true,
      maxLines: 1,
      textScaler: TextScaler.linear(textScaleFactor),
      style: TextStyle(fontSize: 30, fontFamily: QFontFamily.arabic.rawString),
      textAlign: TextAlign.center,
    );
  }
}
