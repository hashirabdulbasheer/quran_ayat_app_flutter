import 'package:ayat_app/src/presentation/home/home.dart';

class WordByWord extends StatefulWidget {
  final QWord word;
  final double textScaleFactor;

  const WordByWord({
    super.key,
    required this.word,
    this.textScaleFactor = 1.0,
  });

  @override
  State<WordByWord> createState() => _WordByWordState();
}

class _WordByWordState extends State<WordByWord> {
  bool isLocalTranslationDisplayed = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
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
    HomeBloc bloc = context.read<HomeBloc>();
    return StreamBuilder<bool?>(
        initialData: bloc.wordTranslationStatus$.value,
        stream: bloc.wordTranslationStatus$,
        builder: (context, snapshot) {
          bool isEnabled = snapshot.hasData ? snapshot.data as bool : true;
          // is enabled shows if the word by word translations have to be displayed or not
          // if its enabled then we can directly show the translations
          // if its not enabled then we do the animation
          if (isEnabled) {
            return _TranslationBox(
              text: text,
              scaleFactor: scaleFactor,
            );
          }

          return AnimatedSize(
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: AnimatedSlide(
              offset: isLocalTranslationDisplayed
                  ? Offset.zero
                  : const Offset(0, -0.5),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
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
            ),
          );
        });
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
