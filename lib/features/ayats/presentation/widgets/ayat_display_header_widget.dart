import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:noble_quran/models/surah_title.dart';

import '../../../../misc/design/design_system.dart';
import '../../../../utils/utils.dart';
import '../../../newAyat/data/surah_index.dart';

class QuranAyatHeaderWidget extends StatelessWidget {
  final List<NQSurahTitle> surahTitles;
  final NQSurahTitle? currentlySelectedSurah;
  final SurahIndex currentIndex;

  final Function(NQSurahTitle) onSurahSelected;
  final Function(int) onAyaNumberSelected;

  const QuranAyatHeaderWidget({
    super.key,
    required this.surahTitles,
    required this.onSurahSelected,
    required this.onAyaNumberSelected,
    required this.currentlySelectedSurah,
    required this.currentIndex,
  });

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
            child: DropdownSearch<NQSurahTitle>(
              items: surahTitles,
              enabled: true,
              itemAsString: (NQSurahTitle title) =>
                  "(${title.number}) ${title.transliterationEn}",
              popupProps: PopupPropsMultiSelection.dialog(
                showSearchBox: true,
                dialogProps: const DialogProps(
                  backgroundColor: QuranDS.screenBackgroundLittleDarker,
                ),
                itemBuilder: _customItem,
                searchFieldProps: const TextFieldProps(
                  style: QuranDS.textTitleSmall,
                ),
              ),
              dropdownDecoratorProps: const DropDownDecoratorProps(
                baseStyle: QuranDS.textTitleSmall,
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
                child: DropdownSearch<int>(
                  popupProps: PopupPropsMultiSelection.dialog(
                    showSearchBox: true,
                    itemBuilder: _customAyaItem,
                    dialogProps: const DialogProps(
                      backgroundColor: QuranDS.screenBackgroundLittleDarker,
                    ),
                    searchFieldProps: const TextFieldProps(
                      style: QuranDS.textTitleSmall,
                    ),
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
                    baseStyle: QuranDS.textTitleSmall,
                    dropdownSearchDecoration: InputDecoration(
                      labelText: "Ayat",
                      hintText: "ayat index",
                    ),
                  ),
                  items: List<int>.generate(
                    currentlySelectedSurah?.totalVerses ?? 0,
                    (i) => i + 1,
                  ),
                  onChanged: (value) =>
                      onAyaNumberSelected(value != null ? value - 1 : 0),
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

  Widget _customItem(
    BuildContext _,
    NQSurahTitle title,
    bool isSelected,
  ) {
    return ListTile(
      selected: isSelected,
      title: Text("${title.number}. ${title.transliterationEn}"),
      subtitle: Text(title.translationEn),
    );
  }

  Widget _customAyaItem(
    BuildContext _,
    int ayaIndex,
    bool isSelected,
  ) {
    return ListTile(
      selected: isSelected,
      title: Text("$ayaIndex"),
    );
  }
}
