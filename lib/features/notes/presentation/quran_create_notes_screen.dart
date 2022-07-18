import 'package:flutter/material.dart';
import '../../../misc/enums/quran_status_enum.dart';
import '../../../models/qr_user_model.dart';
import '../../../utils/utils.dart';
import '../../auth/domain/auth_factory.dart';
import '../domain/entities/quran_note.dart';
import '../domain/notes_manager.dart';
import 'widgets/offline_header_widget.dart';

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
                const QuranOfflineHeaderWidget(),
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
                widget.note == null
                    ? _createControlButton(context)
                    : _updateControlButton(context)
              ],
            ),
          ),
        ));
  }

  Widget _createControlButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
              child: SizedBox(
            height: 50,
            child: ElevatedButton(
                onPressed: () {
                  _createButtonPressed(() {
                    Navigator.of(context).pop();
                  });
                },
                child: const Text("Save")),
          ))
        ],
      ),
    );
  }

  Widget _updateControlButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
              child: SizedBox(
            height: 50,
            child: ElevatedButton(
                onPressed: () {
                  _updateButtonPressed();
                },
                child: const Text("Update")),
          )),
          const SizedBox(
            width: 20,
          ),
          Expanded(
              child: SizedBox(
            height: 50,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red),
                onPressed: () async {
                  _deleteButtonPressed(() {
                    Navigator.of(context).pop();
                  });
                },
                child: const Text("Delete")),
          ))
        ],
      ),
    );
  }

  ///
  ///  BUTTON ACTIONS
  ///
  _createButtonPressed(Function onComplete) async {
    if (_notesController.text.isNotEmpty) {
      QuranUser? user = QuranAuthFactory.engine.getUser();
      if (user != null) {
        QuranNote note = QuranNote(
            suraIndex: widget.suraIndex,
            ayaIndex: widget.ayaIndex,
            note: _notesController.text,
            createdOn: DateTime.now().millisecondsSinceEpoch,
            localId: QuranUtils.uniqueId(),
            status: QuranStatusEnum.created);
        await QuranNotesManager.instance.create(user.uid, note);
        onComplete();
      }
    } else {
      _showMessage("Sorry 😔, please enter a note");
    }
  }

  _deleteButtonPressed(Function onComplete) async {
    QuranUser? user = QuranAuthFactory.engine.getUser();
    if (user != null) {
      Widget okButton = TextButton(
        style: TextButton.styleFrom(primary: Colors.red),
        child: const Text("Delete"),
        onPressed: () {
          if (widget.note != null) {
            QuranNotesManager.instance.delete(user.uid, widget.note!);
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
    if (_notesController.text.isNotEmpty) {
      QuranUser? user = QuranAuthFactory.engine.getUser();
      if (user != null) {
        QuranNote note = widget.note!.copyWith(
            createdOn: DateTime.now().millisecondsSinceEpoch,
            note: _notesController.text);
        QuranNotesManager.instance.update(user.uid, note);
        _showMessage("Updated 👍");
      }
    } else {
      _showMessage("Sorry 😔, please enter a note");
    }
  }

  _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
