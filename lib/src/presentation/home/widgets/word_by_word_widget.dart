import 'package:ayat_app/src/presentation/home/home.dart';

class WordByWord extends StatelessWidget {
  final QWord word;
  final double textScaleFactor;

  const WordByWord({
    super.key,
    required this.word,
    this.textScaleFactor = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ArabicText(
          text: word.ar,
          textScaleFactor: textScaleFactor,
        ),
        BoxedText(
          text: word.tr,
          textScaleFactor: textScaleFactor,
        ),
      ],
    );
  }
}
