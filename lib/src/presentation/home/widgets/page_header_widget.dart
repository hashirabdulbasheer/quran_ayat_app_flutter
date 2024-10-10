import 'package:ayat_app/src/presentation/home/home.dart';


class PageHeader extends StatelessWidget {
  final double readingProgress;

  final List<SuraTitle> surahTitles;
  final SurahIndex currentIndex;

  final Function(SurahIndex) onSelection;

  const PageHeader({
    super.key,
    required this.readingProgress,
    required this.surahTitles,
    required this.onSelection,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: SuraAyaSelector(
            surahTitles: surahTitles,
            currentIndex: currentIndex,
            onSelection: onSelection,
          ),
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: ReadingProgressIndicator(
            progress: readingProgress,
          ),
        ),
      ].spacerDirectional(height: 10),
    );
  }
}
