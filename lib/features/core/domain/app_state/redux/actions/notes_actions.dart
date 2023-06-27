import '../../../../../notes/domain/entities/quran_note.dart';
import 'actions.dart';

/// NOTES ACTIONS
///
class AppStateFetchNotesAction extends AppStateAction {}

class AppStateFetchNotesSucceededAction extends AppStateAction {
  final List<QuranNote> fetchedNotes;

  AppStateFetchNotesSucceededAction(
      this.fetchedNotes,
      );
}

class AppStateCreateNoteAction extends AppStateAction {
  final QuranNote note;

  AppStateCreateNoteAction({
    required this.note,
  });
}

class AppStateCreateNoteSucceededAction extends AppStateAction {}

class AppStateDeleteNoteAction extends AppStateAction {
  final QuranNote note;

  AppStateDeleteNoteAction({
    required this.note,
  });
}

class AppStateDeleteNoteSucceededAction extends AppStateAction {}

class AppStateUpdateNoteAction extends AppStateAction {
  final QuranNote note;

  AppStateUpdateNoteAction({
    required this.note,
  });
}

class AppStateUpdateNoteSucceededAction extends AppStateAction {}

class AppStateNotesFailureAction extends AppStateAction {
  final String message;

  AppStateNotesFailureAction({
    required this.message,
  });
}
