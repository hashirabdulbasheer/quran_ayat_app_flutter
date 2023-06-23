import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../models/qr_user_model.dart';
import '../domain/entities/quran_note.dart';
import '../domain/notes_manager.dart';
import 'quran_create_notes_screen.dart';
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
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Notes"),
          actions: [
            IconButton(
              onPressed: () => _exportTags(),
              icon: const Icon(
                Icons.share,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            const QuranOfflineHeaderWidget(),
            Expanded(
              child: FutureBuilder<List<QuranNote>>(
                future: QuranNotesManager.instance.fetchAll(widget.user.uid),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<QuranNote>> snapshot,
                ) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    default:
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        List<QuranNote> notes =
                            snapshot.data as List<QuranNote>;
                        if (notes.isEmpty) {
                          return const Center(child: Text('No notes'));
                        }

                        return ListView.separated(
                          itemBuilder: (
                            context,
                            index,
                          ) {
                            return ListTile(
                              title: QuranViewNoteItemWidget(
                                context: context,
                                note: notes[index],
                              ),
                              onTap: () => {
                                Navigator.push<void>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        QuranCreateNotesScreen(
                                      note: notes[index],
                                      suraIndex: notes[index].suraIndex,
                                      ayaIndex: notes[index].ayaIndex,
                                    ),
                                  ),
                                ).then((value) {
                                  setState(() {});
                                }),
                              },
                            );
                          },
                          separatorBuilder: (
                            context,
                            index,
                          ) {
                            return const Divider(thickness: 1);
                          },
                          itemCount: notes.length,
                        );
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportTags() async {
    String exported = "";
    List<QuranNote> allNotes =
        await QuranNotesManager.instance.fetchAll(widget.user.uid);
    for (QuranNote note in allNotes) {
      String noteString =
          "${note.suraIndex}:${note.ayaIndex}, ${note.note}, ${note.createdOn} ";
      exported += "$noteString\n";
    }

    Share.share(
      'Notes exported from uxQuran QuranAyat app: https://uxquran.com\n\n$exported',
    );
  }
}
