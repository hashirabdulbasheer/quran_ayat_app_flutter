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

class AppStateNoteOperationsResponseBaseAction extends AppStateAction {
  final String message;

  AppStateNoteOperationsResponseBaseAction({
    required this.message,
  });
}

class AppStateCreateNoteAction extends AppStateAction {
  final QuranNote note;

  AppStateCreateNoteAction({
    required this.note,
  });
}

class AppStateCreateNoteSucceededAction
    extends AppStateNoteOperationsResponseBaseAction {
  AppStateCreateNoteSucceededAction({required super.message});
}

class AppStateDeleteNoteAction extends AppStateAction {
  final QuranNote note;

  AppStateDeleteNoteAction({
    required this.note,
  });
}

class AppStateDeleteNoteSucceededAction
    extends AppStateNoteOperationsResponseBaseAction {
  AppStateDeleteNoteSucceededAction({required super.message});
}

class AppStateUpdateNoteAction extends AppStateAction {
  final QuranNote note;

  AppStateUpdateNoteAction({
    required this.note,
  });
}

class AppStateUpdateNoteSucceededAction
    extends AppStateNoteOperationsResponseBaseAction {
  AppStateUpdateNoteSucceededAction({required super.message});
}

class AppStateNotesFailureAction
    extends AppStateNoteOperationsResponseBaseAction {
  AppStateNotesFailureAction({required super.message});
}
