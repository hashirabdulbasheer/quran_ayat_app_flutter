import 'package:ayat_app/src/core/extensions/widget_spacer_extension.dart';
import 'package:ayat_app/src/domain/models/sura_title.dart';
import 'package:ayat_app/src/domain/models/surah_index.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

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
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 3,
            child: DropdownSearch<SuraTitle>(
              items: (f, cs) => surahTitles,
              enabled: true,
              compareFn: (item, selectedItem) =>
                  item.number == selectedItem.number,
              itemAsString: (SuraTitle title) =>
                  "(${title.number}) ${title.transliterationEn}",
              popupProps: const PopupProps.menu(showSearchBox: true),
              dropdownBuilder: (context, title) => ListTile(
                title: Text("${title?.number}. ${title?.transliterationEn}"),
                subtitle: Text("${title?.translationEn}"),
              ),
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
                  height: 80,
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
