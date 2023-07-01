import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:noble_quran/models/surah_title.dart';

import '../../../../misc/constants/string_constants.dart';
import '../../../../models/qr_user_model.dart';
import '../../../../utils/logger_utils.dart';
import '../../../../utils/utils.dart';
import '../../../auth/domain/auth_factory.dart';
import '../../../auth/presentation/quran_login_screen.dart';
import '../../../core/domain/app_state/app_state.dart';
import '../../../core/presentation/shimmer.dart';
import '../../../notes/domain/entities/quran_note.dart';
import '../../../notes/domain/notes_manager.dart';
import '../../../notes/presentation/quran_create_notes_screen.dart';
import '../../../notes/presentation/widgets/offline_header_widget.dart';
import 'font_scaler_widget.dart';

class QuranAyatDisplayNotesWidget extends StatefulWidget {
  final NQSurahTitle? currentlySelectedSurah;
  final int currentlySelectedAya;
  final ValueNotifier<bool> continuousMode;

  const QuranAyatDisplayNotesWidget({
    Key? key,
    required this.currentlySelectedSurah,
    required this.currentlySelectedAya,
    required this.continuousMode,
  }) : super(key: key);

  @override
  State<QuranAyatDisplayNotesWidget> createState() =>
      _QuranAyatDisplayNotesWidgetState();
}

class _QuranAyatDisplayNotesWidgetState
    extends State<QuranAyatDisplayNotesWidget> {
  @override
  Widget build(BuildContext context) {
    return QuranFontScalerWidget(body: _body);
  }

  Widget _body(
    BuildContext context,
    double fontScale,
  ) {
    QuranUser? user = QuranAuthFactory.engine.getUser();
    // logged in
    if (widget.currentlySelectedSurah == null) {
      return Container();
    }

    int? surahIndex = widget.currentlySelectedSurah?.number;
    List<QuranNote> notes = [];
    if (surahIndex != null) {
      notes = _fetchNotes(
        surahIndex,
        widget.currentlySelectedAya,
      );
    }

    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        const QuranOfflineHeaderWidget(),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 50,
          decoration: const BoxDecoration(
            border: Border.fromBorderSide(
              BorderSide(color: Colors.black12),
            ),
            color: Colors.black12,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          padding: const EdgeInsets.fromLTRB(
            10,
            0,
            10,
            0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Notes"),
              ElevatedButton(
                onPressed: () => {
                  if (_isInteractionAllowedOnScreen())
                    {_goToCreateNoteScreen()}
                  else
                    {_showMessage(QuranStrings.contPlayMessage)},
                },
                child: const Text("Add"),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        QuranShimmer(
          isLoading: StoreProvider.of<AppState>(context).state.notes.isLoading,
          child: _bodyContent(
            surahIndex,
            user,
            notes,
            fontScale,
          ),
        ),
      ],
    );
  }

  Widget _bodyContent(
    int? surahIndex,
    QuranUser? user,
    List<QuranNote>? notes,
    double fontScale,
  ) {
    if (surahIndex != null &&
        user != null &&
        notes != null &&
        notes.isNotEmpty) {
      return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: notes.length,
        shrinkWrap: true,
        separatorBuilder: (
          BuildContext context,
          int index,
        ) {
          return const Divider(
            thickness: 1,
          );
        },
        itemBuilder: (
          BuildContext context,
          int index,
        ) {
          TextDirection textDirection = TextDirection.ltr;
          if (!QuranUtils.isEnglish(notes[index].note)) {
            textDirection = TextDirection.rtl;
          }

          return Directionality(
            textDirection: textDirection,
            child: ListTile(
              onTap: () => {
                if (_isInteractionAllowedOnScreen())
                  {
                    _goToCreateNoteScreen(
                      note: notes[index],
                    ),
                  }
                else
                  {
                    _showMessage(
                      QuranStrings.contPlayMessage,
                    ),
                  },
              },
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notes[index].note,
                      textScaleFactor: fontScale,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      QuranNotesManager.instance.formattedDate(
                        notes[index].createdOn,
                      ),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    return TextButton(
      onPressed: () => _goToCreateNoteScreen(),
      child: const SizedBox(
        height: 100,
        child: Center(child: Text("Add Note")),
      ),
    );
  }

  bool _isInteractionAllowedOnScreen() {
    // disable all interactions if continuous play mode is on
    return !widget.continuousMode.value;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _goToLoginScreen() {
    Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (context) => const QuranLoginScreen()),
    ).then((value) {
      setState(() {});
    });
  }

  void _goToCreateNoteScreen({QuranNote? note}) {
    QuranUser? user = QuranAuthFactory.engine.getUser();
    if (user == null) {
      _goToLoginScreen();
    } else {
      if (widget.currentlySelectedSurah != null) {
        int? surahIndex = widget.currentlySelectedSurah?.number;
        if (surahIndex != null) {
          Navigator.push<void>(
            context,
            MaterialPageRoute(
              builder: (context) => QuranCreateNotesScreen(
                note: note,
                suraIndex: surahIndex,
                ayaIndex: widget.currentlySelectedAya,
              ),
            ),
          ).then((value) {
            setState(() {});
          });
          QuranLogger.logAnalytics("add_note");
        }
      }
    }
  }

  List<QuranNote> _fetchNotes(
    int surahIndex,
    int ayaIndex,
  ) {
    return StoreProvider.of<AppState>(context).state.notes.getNotes(
              surahIndex,
              ayaIndex,
            ) ??
        [];
  }
}
