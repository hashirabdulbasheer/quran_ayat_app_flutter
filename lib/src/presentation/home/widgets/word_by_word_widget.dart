import 'package:ayat_app/src/presentation/home/home.dart';

class WordByWord extends StatefulWidget {
  final QWord word;
  final double textScaleFactor;
  final bool isTranslationDisplayed;

  const WordByWord({
    super.key,
    required this.word,
    this.textScaleFactor = 1.0,
    this.isTranslationDisplayed = false,
  });

  @override
  State<WordByWord> createState() => _WordByWordState();
}

class _WordByWordState extends State<WordByWord> {
  late bool isLocalTranslationDisplayed;

  @override
  void initState() {
    super.initState();
    isLocalTranslationDisplayed = widget.isTranslationDisplayed;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // if forcefully displayed then no action
        if (widget.isTranslationDisplayed) return;
        // else
        setState(() {
          isLocalTranslationDisplayed = !isLocalTranslationDisplayed;
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
          AnimatedSize(
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter, // Key for top-to-bottom expansion
            child: AnimatedSlide(
              // New sliding animation
              offset: isLocalTranslationDisplayed
                  ? Offset.zero
                  : const Offset(0, -0.5),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              child: AnimatedOpacity(
                opacity: isLocalTranslationDisplayed ? 1 : 0,
                duration: const Duration(milliseconds: 100),
                child: isLocalTranslationDisplayed
                    ? Directionality(
                        textDirection: TextDirection.ltr,
                        child: BoxedText(
                          text: widget.word.tr,
                          textScaleFactor: widget.textScaleFactor,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
