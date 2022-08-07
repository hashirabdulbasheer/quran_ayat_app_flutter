import 'package:flutter/material.dart';
import 'package:noble_quran/models/bookmark.dart';
import '../../../utils/prefs_utils.dart';

class QuranBookmarkIconWidget extends StatefulWidget {
  final int currentSurahIndex;
  final int currentAyaIndex;
  final Function onGoToButtonPressed;
  final Function onSaveButtonPressed;
  final Function? onCancelButtonPressed;
  final Function? onClearButtonPressed;

  const QuranBookmarkIconWidget(
      {Key? key,
      required this.currentSurahIndex,
      required this.currentAyaIndex,
      required this.onGoToButtonPressed,
      required this.onSaveButtonPressed,
      this.onCancelButtonPressed,
      this.onClearButtonPressed})
      : super(key: key);

  @override
  State<QuranBookmarkIconWidget> createState() =>
      _QuranBookmarkIconWidgetState();
}

class _QuranBookmarkIconWidgetState extends State<QuranBookmarkIconWidget> {
  NQBookmark? _currentBookmark;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<NQBookmark?>(
      future: QuranPreferences.getBookmark(),
      builder: (BuildContext context, AsyncSnapshot<NQBookmark?> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator());
          default:
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              _currentBookmark = snapshot.data;
              return IconButton(
                  tooltip: "display bookmark options",
                  onPressed: () {
                    _showBookmarkAlertDialog(_currentBookmark);
                  },
                  icon: _isThisBookmarkedAya(_currentBookmark)
                      ? const Icon(Icons.bookmark)
                      : const Icon(Icons.bookmark_border_outlined));
            }
        }
      },
    );
  }

  void _showBookmarkAlertDialog(NQBookmark? currentBookmark) {
    if (currentBookmark == null) {
      // no bookmark saved
      _showFirstTimeBookmarkAlertDialog();
    } else {
      // there is a previous bookmark
      _showMultipleOptionTimeBookmarkAlertDialog(currentBookmark);
    }
  }

  void _showFirstTimeBookmarkAlertDialog() {
    AlertDialog alert;

    // no bookmark saved
    Widget okButton = TextButton(
      child: const Text("Save"),
      onPressed: () {
        widget.onSaveButtonPressed();
        Navigator.of(context).pop();
        setState(() {});
      },
    );

    Widget cancelButton = TextButton(
      child: const Text("Cancel", style: TextStyle(color: Colors.black45)),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    alert = AlertDialog(
      content: const Text("Do you want to bookmark this aya?"),
      actions: [cancelButton, okButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _showMultipleOptionTimeBookmarkAlertDialog(NQBookmark bookmark) {
    AlertDialog alert;
    Widget saveButton = TextButton(
      child: const Text("Save bookmark",
          style: TextStyle(fontWeight: FontWeight.bold)),
      onPressed: () {
        widget.onSaveButtonPressed();
        Navigator.of(context).pop();
        setState(() {});
      },
    );

    Widget clearButton = TextButton(
      child: const Text("Clear bookmark",
          style: TextStyle(fontWeight: FontWeight.bold)),
      onPressed: () {
        QuranPreferences.clearBookmark();
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("👍 Cleared ")));
        setState(() {});
      },
    );

    Widget displayButton = TextButton(
      child: const Text("Go to bookmark",
          style: TextStyle(fontWeight: FontWeight.bold)),
      onPressed: () {
        widget.onGoToButtonPressed(_currentBookmark);
        Navigator.of(context).pop();
      },
    );

    Widget cancelButton = TextButton(
      child: const Text(
        "Cancel",
        style: TextStyle(color: Colors.black45),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    alert = AlertDialog(
      content: const Text("What would you like to do?"),
      actions: [saveButton, displayButton, clearButton, cancelButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  bool _isThisBookmarkedAya(NQBookmark? currentBookmark) {
    if (currentBookmark != null) {
      int currentSurahIndex = widget.currentSurahIndex;
      int currentAyaIndex = widget.currentAyaIndex;
      if (currentSurahIndex == currentBookmark.surah &&
          currentAyaIndex == currentBookmark.ayat) {
        return true;
      }
    }
    return false;
  }
}
