import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:noble_quran/models/surah_title.dart';

import '../../../../utils/utils.dart';
import '../../../newAyat/data/surah_index.dart';

class QuranAyatHeaderWidget extends StatelessWidget {
  final List<NQSurahTitle> surahTitles;
  final NQSurahTitle? currentlySelectedSurah;
  final SurahIndex currentIndex;

  final Function(NQSurahTitle) onSurahSelected;
  final Function(int) onAyaNumberSelected;

  const QuranAyatHeaderWidget({
    Key? key,
    required this.surahTitles,
    required this.onSurahSelected,
    required this.onAyaNumberSelected,
    required this.currentlySelectedSurah,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 2,
          child: Semantics(
            enabled: true,
            excludeSemantics: true,
            label: 'dropdown to select surah',
            child: SizedBox(
              height: 80,
              child: DropdownSearch<NQSurahTitle>(
                items: surahTitles,
                enabled: true,
                itemAsString: (NQSurahTitle title) => "${title.transliterationEn} (${title.translationEn})",
                popupProps: const PopupPropsMultiSelection.menu(),
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Surah",
                    hintText: "select surah",
                  ),
                  textAlign: TextAlign.start,
                ),
                onChanged: (value) => onSurahSelected(
                  value ?? surahTitles.first,
                ),
                selectedItem: currentlySelectedSurah,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Semantics(
            enabled: true,
            excludeSemantics: true,
            label: 'dropdown to select ayat number',
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                8,
                8,
                8,
                8,
              ),
              child: SizedBox(
                width: 100,
                height: 80,
                child: DropdownSearch<int>(
                  popupProps: const PopupPropsMultiSelection.menu(
                    showSearchBox: true,
                  ),
                  filterFn: (
                    item,
                    filter,
                  ) =>
                      _ayatNumberDropdownSearchFilterFn(
                    filter,
                    item,
                  ),
                  enabled: true,
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: "Ayat",
                      hintText: "ayat index",
                    ),
                  ),
                  items: List<int>.generate(
                    currentlySelectedSurah?.totalVerses ?? 0,
                    (i) => i + 1,
                  ),
                  onChanged: (value) => onAyaNumberSelected(value != null ? value - 1 : 0),
                  selectedItem: currentIndex.human.aya,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool _ayatNumberDropdownSearchFilterFn(
    String filter,
    int item,
  ) {
    if (filter.isEmpty) {
      return true;
    }
    if ("$item" == QuranUtils.replaceFarsiNumber(filter)) {
      return true;
    }

    return false;
  }
}
