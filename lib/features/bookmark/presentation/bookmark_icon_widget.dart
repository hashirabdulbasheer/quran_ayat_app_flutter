import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:quran_ayat/features/newAyat/data/surah_index.dart';
import 'package:redux/redux.dart';

import '../../core/domain/app_state/app_state.dart';
import '../domain/redux/actions/actions.dart';
import '../domain/redux/bookmark_state.dart';

class QuranBookmarkIconWidget extends StatefulWidget {
  final int currentSurah;
  final int currentAya;

  const QuranBookmarkIconWidget({
    Key? key,
    required this.currentSurah,
    required this.currentAya,
  }) : super(key: key);

  @override
  State<QuranBookmarkIconWidget> createState() =>
      _QuranBookmarkIconWidgetState();
}

class _QuranBookmarkIconWidgetState extends State<QuranBookmarkIconWidget> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BookmarkState>(
      converter: (Store<AppState> store) => store.state.reader.bookmarkState,
      builder: (
        BuildContext context,
        BookmarkState state,
      ) {
        return IconButton(
          tooltip: "display bookmark options",
          onPressed: () => _showBookmarkConfirmationAlertDialog(),
          icon: _isThisBookmarkedAya(
            state,
            widget.currentSurah,
            widget.currentAya,
          )
              ? const Icon(Icons.bookmark)
              : const Icon(Icons.bookmark_border_outlined),
        );
      },
    );
  }

  void _showBookmarkConfirmationAlertDialog() {
    AlertDialog alert;

    // no bookmark saved
    Widget okButton = TextButton(
      child: const Text("Save"),
      onPressed: () => {
        StoreProvider.of<AppState>(context).dispatch(SaveBookmarkAction(
          index: SurahIndex(
            widget.currentSurah,
            widget.currentAya,
          ),
        )),
        Navigator.of(context).pop(),
      },
    );

    Widget cancelButton = TextButton(
      child: const Text(
        "Cancel",
      ),
      onPressed: () => {Navigator.of(context).pop()},
    );

    alert = AlertDialog(
      content: const Text("Do you want to bookmark this aya?"),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  bool _isThisBookmarkedAya(
    BookmarkState state,
    int currentSurah,
    int currentAya,
  ) {
    if (state.index != null) {
      if (currentSurah == state.index?.sura && currentAya == state.index?.aya) {
        return true;
      }
    }

    return false;
  }
}
