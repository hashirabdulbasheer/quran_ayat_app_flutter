import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../../../notes/domain/entities/quran_note.dart';
import '../../../tags/domain/redux/tag_aya/tag_operations_state.dart';
import 'redux/actions/actions.dart';
export "redux/reducers/reducer.dart";
export "redux/middleware/middleware.dart";
export "redux/actions/actions.dart";

/// STATE
///
@immutable
class AppState extends Equatable {
  final TagOperationsState tags;
  final List<QuranNote> originalNotes;
  final Map<String, List<QuranNote>> notes;
  final AppStateActionStatus lastActionStatus;
  final bool isLoading;

  const AppState({
    this.tags = const TagOperationsState(),
    this.notes = const {},
    this.originalNotes = const [],
    this.lastActionStatus = const AppStateActionStatus(
      action: "",
      message: "",
    ),
    this.isLoading = false,
  });

  AppState copyWith({
    TagOperationsState? tags,
    List<QuranNote>? originalNotes,
    Map<String, List<QuranNote>>? notes,
    AppStateActionStatus? lastActionStatus,
    bool? isLoading,
  }) {
    return AppState(
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      originalNotes: originalNotes ?? this.originalNotes,
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
    return "Tags: ${tags.toString()}, Notes: ${originalNotes.length}, Status: $lastActionStatus, isLoading: $isLoading";
  }

  @override
  List<Object> get props => [
        tags,
        originalNotes,
        notes,
        lastActionStatus,
        isLoading,
      ];
}
