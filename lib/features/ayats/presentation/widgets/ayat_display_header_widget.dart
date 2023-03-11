import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:noble_quran/models/surah_title.dart';

import '../../../../utils/utils.dart';

class QuranAyatHeaderWidget extends StatelessWidget {
  final List<NQSurahTitle> surahTitles;
  final NQSurahTitle? currentlySelectedSurah;
  final int currentlySelectedAya;
  final ValueNotifier<bool> continuousMode;

  final Function(NQSurahTitle?) onSurahSelected;
  final Function(int?) onAyaNumberSelected;

  const QuranAyatHeaderWidget({
    Key? key,
    required this.surahTitles,
    required this.onSurahSelected,
    required this.onAyaNumberSelected,
    required this.continuousMode,
    required this.currentlySelectedSurah,
    required this.currentlySelectedAya,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      builder: (
        BuildContext context,
        bool isContinuousPlay,
        Widget? child,
      ) {
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
                    enabled: !isContinuousPlay,
                    popupProps: const PopupPropsMultiSelection.menu(),
                    itemAsString: (surah) =>
                        '(${surah.number}) ${surah.transliterationEn}',
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Surah",
                        hintText: "select surah",
                      ),
                      textAlign: TextAlign.start,
                    ),
                    onChanged: (value) => onSurahSelected(value),
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
                      enabled: !isContinuousPlay,
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
                      onChanged: (value) => onAyaNumberSelected(value),
                      selectedItem: currentlySelectedAya,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
      valueListenable: continuousMode,
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
