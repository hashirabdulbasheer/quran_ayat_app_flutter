import 'package:flutter/material.dart';

import '../../../models/qr_user_model.dart';
import '../domain/entities/quran_note.dart';
import '../domain/notes_manager.dart';
import 'quran_create_notes_screen.dart';
import 'widgets/offline_header_widget.dart';

class QuranViewNotesScreen extends StatefulWidget {
  final QuranUser user;

  const QuranViewNotesScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<QuranViewNotesScreen> createState() => _QuranViewNotesScreenState();
}

class _QuranViewNotesScreenState extends State<QuranViewNotesScreen> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(title: const Text("Notes")), body: _body(context)),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      children: [
        const QuranOfflineHeaderWidget(),
        Expanded(
          child: FutureBuilder<List<QuranNote>>(
            future: QuranNotesManager.instance.fetchAll(widget.user.uid),
            builder: (BuildContext context,
                AsyncSnapshot<List<QuranNote>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()));
                default:
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    List<QuranNote> notes = snapshot.data as List<QuranNote>;
                    if (notes.isEmpty) {
                      return const Center(child: Text('No notes'));
                    }
                    return ListView.separated(
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: _noteItem(context, notes[index]),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        QuranCreateNotesScreen(
                                          note: notes[index],
                                          suraIndex: notes[index].suraIndex,
                                          ayaIndex: notes[index].ayaIndex,
                                        )),
                              ).then((value) {
                                setState(() {});
                              });
                            },
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider(thickness: 1);
                        },
                        itemCount: notes.length);
                  }
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _noteItem(BuildContext context, QuranNote note) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${note.suraIndex}:${note.ayaIndex}",
                style: Theme.of(context).textTheme.subtitle1),
            const SizedBox(height: 5),
            Text(note.note, style: Theme.of(context).textTheme.bodyText1),
            const SizedBox(height: 10),
            Text(QuranNotesManager.instance.formattedDate(note.createdOn),
                style: Theme.of(context).textTheme.subtitle2),
          ],
        ),
      ),
    );
  }
}
