import 'package:flutter/material.dart';

import '../../domain/entities/quran_note.dart';
import '../../domain/notes_manager.dart';

class QuranViewNoteItemWidget extends StatelessWidget {
  final BuildContext context;
  final QuranNote note;

  const QuranViewNoteItemWidget({
    super.key,
    required this.context,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            "${note.suraIndex + 1}:${note.ayaIndex + 1}",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 5),
          Text(
            note.note,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 10),
          Text(
            QuranNotesManager.instance.formattedDate(note.createdOn),
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}
