import 'package:equatable/equatable.dart';

import '../../../../../notes/domain/entities/quran_note.dart';
import '../../../../../tags/domain/entities/quran_tag.dart';

export "tag_actions.dart";

/// ACTIONS
///

class AppStateAction extends Equatable {
  @override
  String toString() {
    return "$runtimeType";
  }

  @override
  List<Object> get props => [];
}

class AppStateActionStatus extends Equatable {
  final String action;
  final String message;

  const AppStateActionStatus({
    required this.action,
    required this.message,
  });

  @override
  List<Object> get props => [
        action,
        message,
      ];

  @override
  String toString() {
    return '{action: $action, message: $message}';
  }
}

class AppStateInitializeAction extends AppStateAction {}

class AppStateResetAction extends AppStateAction {}

/// TAG ACTIONS
///
class AppStateFetchTagsAction extends AppStateAction {}

class AppStateLoadingAction extends AppStateAction {
  final bool isLoading;

  AppStateLoadingAction({
    required this.isLoading,
  });
}

class AppStateTagBaseAction extends AppStateAction {
  final int surahIndex;
  final int ayaIndex;
  final String tag;

  AppStateTagBaseAction({
    required this.surahIndex,
    required this.ayaIndex,
    required this.tag,
  });
}

/// Response
///

class AppStateFetchTagsSucceededAction extends AppStateAction {
  final List<QuranTag> fetchedTags;

  AppStateFetchTagsSucceededAction(
      this.fetchedTags,
      );
}

class AppStateModifyTagResponseBaseAction extends AppStateAction {
  final String message;

  AppStateModifyTagResponseBaseAction({
    required this.message,
  });
}

class AppStateResetStatusAction extends AppStateAction {}

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

