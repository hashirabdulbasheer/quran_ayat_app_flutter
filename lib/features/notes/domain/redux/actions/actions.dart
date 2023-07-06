import '../../../../core/domain/app_state/redux/actions/actions.dart';
import '../../entities/quran_note.dart';

/// NOTES ACTIONS
///
class InitializeNotesAction extends AppStateAction {}

class CreateNoteAction extends AppStateAction {
  final QuranNote note;

  CreateNoteAction({
    required this.note,
  });

  @override
  String toString() {
    return '{action: ${super.toString()}, note: ${note.toString()}';
  }
}

class CreateNoteSucceededAction extends NoteOperationsResponseBaseAction {
  CreateNoteSucceededAction({required super.message});
}

class DeleteNoteAction extends AppStateAction {
  final QuranNote note;

  DeleteNoteAction({
    required this.note,
  });

  @override
  String toString() {
    return '{action: ${super.toString()}, note: ${note.toString()}';
  }
}

class DeleteNoteSucceededAction extends NoteOperationsResponseBaseAction {
  DeleteNoteSucceededAction({required super.message});
}

class UpdateNoteAction extends AppStateAction {
  final QuranNote note;

  UpdateNoteAction({
    required this.note,
  });

  @override
  String toString() {
    return '{action: ${super.toString()}, note: ${note.toString()}';
  }
}

class UpdateNoteSucceededAction extends NoteOperationsResponseBaseAction {
  UpdateNoteSucceededAction({required super.message});
}

class NotesFailureAction extends NoteOperationsResponseBaseAction {
  NotesFailureAction({required super.message});
}

class ResetNotesStatusAction extends AppStateAction {}

class NotesLoadingAction extends AppStateAction {
  final bool isLoading;

  NotesLoadingAction({
    required this.isLoading,
  });

  @override
  String toString() {
    return '{action: ${super.toString()}, isLoading: $isLoading}';
  }
}

class FetchNotesAction extends AppStateAction {}

class FetchNotesSucceededAction extends AppStateAction {
  final List<QuranNote> fetchedNotes;

  FetchNotesSucceededAction(
    this.fetchedNotes,
  );

  @override
  String toString() {
    return '{action: ${super.toString()}, fetchedNotes: ${fetchedNotes.length}}';
  }
}

class NoteOperationsResponseBaseAction extends AppStateAction {
  final String message;

  NoteOperationsResponseBaseAction({
    required this.message,
  });

  @override
  String toString() {
    return '{action: ${super.toString()}, message: $message}';
  }
}
