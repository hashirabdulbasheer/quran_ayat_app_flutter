import 'package:ayat_app/src/presentation/home/home.dart';

class WordByWordAya extends StatelessWidget {
  final List<QWord> words;
  final double textScaleFactor;
  final bool isWordByWordTranslationEnabled;

  const WordByWordAya({
    super.key,
    required this.words,
    required this.isWordByWordTranslationEnabled,
    this.textScaleFactor = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.end,
              children: words
                  .map((e) => Padding(
                        padding: const EdgeInsets.only(
                          left: 4,
                          right: 4,
                          top: 10,
                        ),
                        child: WordByWord(
                          word: e,
                          textScaleFactor: textScaleFactor,
                          isWordByWordTranslationEnabled:
                              isWordByWordTranslationEnabled,
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
