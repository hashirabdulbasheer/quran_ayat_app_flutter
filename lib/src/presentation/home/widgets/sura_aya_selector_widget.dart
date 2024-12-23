import 'package:ayat_app/src/presentation/home/home.dart';
import 'package:dropdown_search/dropdown_search.dart';

class SuraAyaSelector extends StatelessWidget {
  final List<SuraTitle> surahTitles;
  final SurahIndex currentIndex;

  final Function(SurahIndex) onSelection;

  const SuraAyaSelector({
    super.key,
    required this.surahTitles,
    required this.onSelection,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 2,
            child: DropdownSearch<SuraTitle>(
              items: (f, cs) => surahTitles,
              enabled: true,
              compareFn: (item, selectedItem) =>
                  item.number == selectedItem.number,
              itemAsString: (SuraTitle title) =>
                  "(${title.number}) ${title.transliterationEn} / ${title.translationEn}",
              popupProps: const PopupProps.menu(showSearchBox: true),
              dropdownBuilder: (context, title) =>
                  Text("${title?.number}. ${title?.transliterationEn}"),
              onChanged: (value) => onSelection(SurahIndex.fromHuman(
                sura: value?.number ?? 1,
                aya: 1,
              )),
              selectedItem: surahTitles[currentIndex.sura],
            ),
          ),
          Expanded(
            child: DropdownSearch<int>(
              enabled: true,
              popupProps: const PopupProps.menu(showSearchBox: true),
              items: (f, cs) => List<int>.generate(
                  surahTitles[currentIndex.sura].totalVerses, (i) => i + 1),
              onChanged: (value) => onSelection(SurahIndex.fromHuman(
                sura: currentIndex.human.sura,
                aya: value ?? 1,
              )),
              dropdownBuilder: (context, aya) => SizedBox(
                  height: 40,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "$aya",
                        textAlign: TextAlign.start,
                      ))),
              selectedItem: currentIndex.human.aya,
            ),
          ),
        ].spacerDirectional(width: 10),
      ),
    );
  }
}
