import 'package:ayat_app/src/presentation/home/home.dart';

class WordByWord extends StatefulWidget {
  final QWord word;
  final bool isWordByWordTranslationEnabled;
  final double textScaleFactor;

  const WordByWord({
    super.key,
    required this.word,
    required this.isWordByWordTranslationEnabled,
    this.textScaleFactor = 1.0,
  });

  @override
  State<WordByWord> createState() => _WordByWordState();
}

class _WordByWordState extends State<WordByWord> {
  bool isLocalTranslationDisplayed = false;
  static const _translationHideTimeSecs = 4;

  @override
  void initState() {
    super.initState();
    isLocalTranslationDisplayed = widget.isWordByWordTranslationEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if(widget.isWordByWordTranslationEnabled) {
          return;
        }
        // show
        setState(() {
          isLocalTranslationDisplayed = !isLocalTranslationDisplayed;
        });
        // hide after some time
        Future.delayed(const Duration(seconds: _translationHideTimeSecs), () {
          setState(() {
            isLocalTranslationDisplayed = false;
          });
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ArabicText(
            text: widget.word.ar,
            textScaleFactor: widget.textScaleFactor,
          ),
          _TranslationText(
            isLocalTranslationDisplayed: isLocalTranslationDisplayed,
            text: widget.word.tr,
            scaleFactor: widget.textScaleFactor,
          ),
        ],
      ),
    );
  }
}

class _TranslationText extends StatelessWidget {
  final bool isLocalTranslationDisplayed;
  final String text;
  final double scaleFactor;

  const _TranslationText({
    required this.isLocalTranslationDisplayed,
    required this.text,
    required this.scaleFactor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: AnimatedOpacity(
        opacity: isLocalTranslationDisplayed ? 1 : 0,
        duration: const Duration(milliseconds: 100),
        child: isLocalTranslationDisplayed
            ? _TranslationBox(
          text: text,
          scaleFactor: scaleFactor,
        )
            : const SizedBox.shrink(),
      ),
    );
  }
}

class _TranslationBox extends StatelessWidget {
  final String text;
  final double scaleFactor;

  const _TranslationBox({
    required this.text,
    required this.scaleFactor,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: BoxedText(
        text: text,
        textScaleFactor: scaleFactor,
      ),
    );
  }
}
