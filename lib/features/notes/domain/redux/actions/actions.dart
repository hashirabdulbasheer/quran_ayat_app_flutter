import '../../../../core/domain/app_state/redux/actions/actions.dart';
import '../../entities/quran_note.dart';

/// NOTES ACTIONS
///
class CreateNoteAction extends AppStateAction {
  final QuranNote note;

  CreateNoteAction({
    required this.note,
  });
}

class CreateNoteSucceededAction
    extends AppStateNoteOperationsResponseBaseAction {
  CreateNoteSucceededAction({required super.message});
}

class DeleteNoteAction extends AppStateAction {
  final QuranNote note;

  DeleteNoteAction({
    required this.note,
  });
}

class DeleteNoteSucceededAction
    extends AppStateNoteOperationsResponseBaseAction {
  DeleteNoteSucceededAction({required super.message});
}

class UpdateNoteAction extends AppStateAction {
  final QuranNote note;

  UpdateNoteAction({
    required this.note,
  });
}

class UpdateNoteSucceededAction
    extends AppStateNoteOperationsResponseBaseAction {
  UpdateNoteSucceededAction({required super.message});
}

class NotesFailureAction extends AppStateNoteOperationsResponseBaseAction {
  NotesFailureAction({required super.message});
}

class ResetNotesStatusAction extends AppStateAction {}

class NotesLoadingAction extends AppStateAction {
  final bool isLoading;

  NotesLoadingAction({
    required this.isLoading,
  });
}
