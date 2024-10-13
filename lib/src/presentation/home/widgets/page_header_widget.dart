import 'package:ayat_app/src/presentation/home/home.dart';

class PageHeader extends StatelessWidget {
  final List<SuraTitle> surahTitles;
  final SurahIndex currentIndex;

  final Function(SurahIndex) onSelection;

  const PageHeader({
    super.key,
    required this.surahTitles,
    required this.onSelection,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: SuraAyaSelector(
        surahTitles: surahTitles,
        currentIndex: currentIndex,
        onSelection: onSelection,
      ),
    );
  }
}
