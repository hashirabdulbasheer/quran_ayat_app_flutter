import 'package:flutter/material.dart';
import '../../../misc/enums/quran_status_enum.dart';
import '../../../models/qr_user_model.dart';
import '../../../utils/utils.dart';
import '../../auth/domain/auth_factory.dart';
import '../domain/entities/quran_note.dart';
import '../domain/notes_manager.dart';
import 'widgets/notes_create_controls_widget.dart';
import 'widgets/notes_update_controls_widget.dart';
import 'widgets/offline_header_widget.dart';

class QuranCreateNotesScreen extends StatefulWidget {
  final int suraIndex;
  final int ayaIndex;
  final QuranNote? note;

  const QuranCreateNotesScreen({
    Key? key,
    required this.suraIndex,
    required this.ayaIndex,
    this.note,
  }) : super(key: key);

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const QuranOfflineHeaderWidget(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Enter your notes for ${widget.suraIndex}:${widget.ayaIndex}",
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _notesController..text = widget.note?.note ?? "",
                maxLines: 10,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 0.0,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            widget.note == null
                ? QuranNotesCreateControlsWidget(
                    onConfirmation: () => {
                      _createButtonPressed(() => {
                            Navigator.of(context).pop(),
                          }),
                    },
                  )
                : QuranUpdateControlsWidget(
                    onDelete: () => {
                      _deleteButtonPressed(() {
                        Navigator.of(context).pop();
                      }),
                    },
                    onUpdate: () => _updateButtonPressed(),
                  ),
          ],
        ),
      ),
    );
  }

  ///
  ///  BUTTON ACTIONS
  ///
  void _createButtonPressed(Function onComplete) async {
    if (_notesController.text.isNotEmpty) {
      QuranUser? user = QuranAuthFactory.engine.getUser();
      if (user != null) {
        QuranNote note = QuranNote(
          suraIndex: widget.suraIndex,
          ayaIndex: widget.ayaIndex,
          note: _notesController.text,
          createdOn: DateTime.now().millisecondsSinceEpoch,
          localId: QuranUtils.uniqueId(),
          status: QuranStatusEnum.created,
        );
        await QuranNotesManager.instance.create(
          user.uid,
          note,
        );
        onComplete();
      }
    } else {
      _showMessage("Sorry 😔, please enter a note");
    }
  }

  void _deleteButtonPressed(Function onComplete) async {
    QuranUser? user = QuranAuthFactory.engine.getUser();
    if (user != null) {
      Widget okButton = TextButton(
        style: TextButton.styleFrom(primary: Colors.red),
        child: const Text("Delete"),
        onPressed: () => {
          if (_deleteNote(user))
            {
              _showMessage("Deleted 👍"),
              Navigator.of(context).pop(),
              onComplete(),
            },
        },
      );

      Widget cancelButton = TextButton(
        child: const Text("Cancel"),
        onPressed: () => {Navigator.of(context).pop()},
      );

      AlertDialog alert = AlertDialog(
        title: const Text("Delete"),
        content: const Text("Are you sure?"),
        actions: [
          okButton,
          cancelButton,
        ],
      );

      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  bool _deleteNote(QuranUser user) {
    QuranNote? noteParam = widget.note;
    if (noteParam != null) {
      QuranNotesManager.instance.delete(
        user.uid,
        noteParam,
      );

      return true;
    }

    return false;
  }

  void _updateButtonPressed() async {
    if (_notesController.text.isNotEmpty) {
      QuranUser? user = QuranAuthFactory.engine.getUser();
      if (user != null) {
        QuranNote? noteParam = widget.note;
        if (noteParam != null) {
          QuranNote note = noteParam.copyWith(
            createdOn: DateTime.now().millisecondsSinceEpoch,
            note: _notesController.text,
          );
          QuranNotesManager.instance.update(
            user.uid,
            note,
          );
          _showMessage("Updated 👍");
        } else {
          _showMessage("Sorry 😔, unable to update the note at the moment.");
        }
      }
    } else {
      _showMessage("Sorry 😔, please enter a note");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
