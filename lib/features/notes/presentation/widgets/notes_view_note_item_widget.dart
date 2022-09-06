import 'package:flutter/material.dart';

import '../../domain/entities/quran_note.dart';
import '../../domain/notes_manager.dart';

class QuranViewNoteItemWidget extends StatelessWidget {
  const QuranViewNoteItemWidget({
    Key? key,
    required this.context,
    required this.note,
  }) : super(key: key);

  final BuildContext context;
  final QuranNote note;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          10,
          20,
          10,
          20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${note.suraIndex}:${note.ayaIndex}",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(height: 5),
            Text(
              note.note,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(height: 10),
            Text(
              QuranNotesManager.instance.formattedDate(note.createdOn),
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ],
        ),
      ),
    );
  }
}
