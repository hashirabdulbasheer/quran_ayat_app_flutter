import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../core/domain/app_state/redux/actions/actions.dart';
import '../entities/quran_note.dart';

@immutable
class NotesState extends Equatable {
  final List<QuranNote> originalNotes;
  final Map<String, List<QuranNote>> notes;
  final AppStateActionStatus lastActionStatus;
  final bool isLoading;

  const NotesState({
    this.originalNotes = const [],
    this.notes = const {},
    this.lastActionStatus = const AppStateActionStatus(
      action: "",
      message: "",
    ),
    this.isLoading = false,
  });

  NotesState copyWith({
    List<QuranNote>? originalNotes,
    Map<String, List<QuranNote>>? notes,
    AppStateActionStatus? lastActionStatus,
    bool? isLoading,
  }) {
    return NotesState(
      originalNotes: originalNotes ?? this.originalNotes,
      notes: notes ?? this.notes,
      lastActionStatus: lastActionStatus ?? this.lastActionStatus,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  List<QuranNote>? getNotes(
    int surahIndex,
    int ayaIndex,
  ) {
    String key = "${surahIndex}_$ayaIndex";

    return notes[key];
  }

  @override
  String toString() {
    return 'NotesState{originalNotes: ${originalNotes.length}, lastActionStatus: $lastActionStatus, isLoading: $isLoading}';
  }

  @override
  List<Object> get props => [
        originalNotes,
        notes,
        lastActionStatus,
        isLoading,
      ];
}
