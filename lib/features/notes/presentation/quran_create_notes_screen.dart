import 'package:flutter/material.dart';
import '../../../models/qr_user_model.dart';
import '../../auth/domain/auth_factory.dart';
import '../domain/entities/quran_note.dart';
import '../domain/notes_factory.dart';

class QuranCreateNotesScreen extends StatefulWidget {
  final int suraIndex;
  final int ayaIndex;
  final QuranNote? note;

  const QuranCreateNotesScreen(
      {Key? key, required this.suraIndex, required this.ayaIndex, this.note})
      : super(key: key);

  @override
  State<QuranCreateNotesScreen> createState() => _QuranCreateNotesScreenState();
}

class _QuranCreateNotesScreenState extends State<QuranCreateNotesScreen> {
  final TextEditingController _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Notes"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                      "Enter your notes for ${widget.suraIndex}:${widget.ayaIndex}"),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    style: const TextStyle(fontFamily: "default"),
                    controller: _notesController
                      ..text = widget.note?.note ?? "",
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.0),
                        )),
                    maxLines: 10,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: _controlButtons(context),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  List<Widget> _controlButtons(BuildContext context) {
    List<Widget> children = [];
    if (widget.note == null) {
      children.add(Expanded(
          child: ElevatedButton(
              onPressed: () {
                _createButtonPressed(() {
                  Navigator.of(context).pop();
                });
              },
              child: const Text("Save"))));
    } else {
      children.add(Expanded(
          child: ElevatedButton(
              onPressed: () {
                _updateButtonPressed();
              },
              child: const Text("Update"))));
      children.add(const SizedBox(
        width: 20,
      ));
      children.add(Expanded(
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.red),
              onPressed: () async {
                _deleteButtonPressed(() {
                  Navigator.of(context).pop();
                });
              },
              child: const Text("Delete"))));
    }
    return children;
  }

  ///
  ///  BUTTON ACTIONS
  ///
  _createButtonPressed(Function onComplete) async {
    QuranUser? user = await QuranAuthFactory.authEngine.getUser();
    if (user != null) {
      QuranNote note = QuranNote(
          suraIndex: widget.suraIndex,
          ayaIndex: widget.ayaIndex,
          note: _notesController.text,
          createdOn: DateTime.now().millisecondsSinceEpoch);
      QuranNotesFactory.engine.create(user.uid, note);
      onComplete();
    }
  }

  _deleteButtonPressed(Function onComplete) async {
    QuranUser? user = await QuranAuthFactory.authEngine.getUser();
    if (user != null) {
      Widget okButton = TextButton(
        style: TextButton.styleFrom(primary: Colors.red),
        child: const Text("Delete"),
        onPressed: () {
          if (widget.note != null) {
            QuranNotesFactory.engine.delete(user.uid, widget.note!);
            _showMessage("Deleted 👍");
            Navigator.of(context).pop();
            onComplete();
          }
        },
      );

      Widget cancelButton = TextButton(
        child: const Text("Cancel"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );

      AlertDialog alert = AlertDialog(
        title: const Text("Delete"),
        content: const Text("Are you sure?"),
        actions: [okButton, cancelButton],
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  _updateButtonPressed() async {
    QuranUser? user = await QuranAuthFactory.authEngine.getUser();
    if (user != null) {
      QuranNote note = widget.note!.copyWith(
          createdOn: DateTime.now().millisecondsSinceEpoch,
          note: _notesController.text);

      QuranNotesFactory.engine.update(user.uid, note);
      _showMessage("Updated 👍");
    }
  }

  _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
