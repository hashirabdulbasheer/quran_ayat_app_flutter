import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:noble_quran/models/surah_title.dart';
import 'package:redux/redux.dart';
import 'package:share_plus/share_plus.dart';

import '../../../models/qr_user_model.dart';
import '../../core/domain/app_state/app_state.dart';
import '../../newAyat/data/surah_index.dart';
import '../domain/entities/quran_note.dart';
import 'widgets/notes_view_note_item_widget.dart';
import 'widgets/offline_header_widget.dart';

class QuranViewNotesScreen extends StatefulWidget {
  final QuranUser user;

  const QuranViewNotesScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<QuranViewNotesScreen> createState() => _QuranViewNotesScreenState();
}

class _QuranViewNotesScreenState extends State<QuranViewNotesScreen> {
  NQSurahTitle? _selectedSurah;
  final List<NQSurahTitle> _suraTitles = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _suraTitles.add(NQSurahTitle(
      number: 0,
      name: "All",
      transliterationEn: "All notes",
      translationEn: "All notes",
      totalVerses: 0,
      revelationType: RevelationType.MECCAN,
    ));
    _suraTitles
        .addAll(StoreProvider.of<AppState>(context).state.reader.surahTitles);
  }

  @override
  Widget build(BuildContext context) {
    List<QuranNote> notes = _notes(
      _selectedSurah,
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Notes"),
          actions: [
            IconButton(
              onPressed: () => _exportNotes(),
              icon: const Icon(
                Icons.share,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            const QuranOfflineHeaderWidget(),
            _suraTitles.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(
                      10,
                      5,
                      10,
                      5,
                    ),
                    child: StoreBuilder<AppState>(builder: (
                      BuildContext context,
                      Store<AppState> store,
                    ) {
                      return DropdownSearch<NQSurahTitle>(
                        items: _suraTitles,
                        enabled: true,
                        itemAsString: (NQSurahTitle title) =>
                            "(${title.number}) ${title.transliterationEn}",
                        popupProps: PopupPropsMultiSelection.dialog(
                          showSearchBox: true,
                          itemBuilder: _customItem,
                          searchFieldProps: const TextFieldProps(
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          baseStyle: TextStyle(fontSize: 12),
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "Surah",
                            hintText: "select surah",
                          ),
                          textAlign: TextAlign.start,
                        ),
                        onChanged: (value) => {
                          setState(() {
                            if (value != null) {
                              if (value.number > 0) {
                                _selectedSurah = value;
                              } else {
                                _selectedSurah = null;
                              }
                            }
                          }),
                        },
                        selectedItem: _selectedSurah,
                      );
                    }),
                  )
                : Container(),
            Expanded(
              child: notes.isEmpty
                  ? const Center(child: Text('No notes'))
                  : ListView.separated(
                      itemBuilder: (
                        context,
                        index,
                      ) {
                        return ListTile(
                          title: QuranViewNoteItemWidget(
                            context: context,
                            note: notes[index],
                          ),
                          onTap: () => _goToEditNoteScreen(
                            note: notes[index],
                            index: SurahIndex(
                              notes[index].suraIndex,
                              notes[index].ayaIndex,
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (
                        context,
                        index,
                      ) {
                        return const Divider(thickness: 1);
                      },
                      itemCount: notes.length,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _goToEditNoteScreen({
    required QuranNote note,
    required SurahIndex index,
  }) {
    Map<String, dynamic> args = <String, dynamic>{};
    args["note"] = note;
    args["index"] = index;
    Navigator.pushNamed(
      context,
      "/createNote",
      arguments: args,
    ).then((value) {
      setState(() {});
    });
  }

  Widget _customItem(
    BuildContext _,
    NQSurahTitle title,
    bool isSelected,
  ) {
    return ListTile(
      selected: isSelected,
      title: title.number > 0
          ? Text("${title.number}. ${title.transliterationEn}")
          : Text(title.transliterationEn),
      subtitle: title.number > 0 ? Text(title.translationEn) : const Text(""),
    );
  }

  Future<void> _exportNotes() async {
    String exported = "";
    List<QuranNote> allNotes =
        StoreProvider.of<AppState>(context).state.notes.originalNotes;
    for (QuranNote note in allNotes) {
      String noteString =
          "${note.suraIndex}:${note.ayaIndex}, ${note.note}, ${note.createdOn} ";
      exported += "$noteString\n";
    }

    Share.share(
      'Notes exported from uxQuran QuranAyat app: https://uxquran.com\n\n$exported',
    );
  }

  List<QuranNote> _notes(
    NQSurahTitle? sura,
  ) {
    List<QuranNote> notes = StoreProvider.of<AppState>(context)
        .state
        .notes
        .originalNotes
        .where(
          (note) => sura != null ? note.suraIndex == sura.number - 1 : true,
        )
        .toList();

    // sort descending by time to show latest on top
    notes.sort((
      a,
      b,
    ) =>
        b.createdOn - a.createdOn);

    return notes;
  }
}
