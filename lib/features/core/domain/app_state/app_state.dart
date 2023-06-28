import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../../../notes/domain/entities/quran_note.dart';
import '../../../tags/domain/entities/quran_tag.dart';
import 'redux/actions/actions.dart';

export "redux/reducers/reducer.dart";
export "redux/middleware/middleware.dart";
export "redux/actions/actions.dart";

/// STATE
///
@immutable
class AppState extends Equatable {
  final List<QuranTag> originalTags;
  final List<QuranNote> originalNotes;
  final Map<String, List<String>> tags;
  final Map<String, List<QuranNote>> notes;
  final AppStateActionStatus lastActionStatus;
  final bool isLoading;

  const AppState({
    this.tags = const {},
    this.notes = const {},
    this.originalTags = const [],
    this.originalNotes = const [],
    this.lastActionStatus = const AppStateActionStatus(
      action: "",
      message: "",
    ),
    this.isLoading = false,
  });

  AppState copyWith({
    List<QuranTag>? originalTags,
    List<QuranNote>? originalNotes,
    Map<String, List<String>>? tags,
    Map<String, List<QuranNote>>? notes,
    AppStateActionStatus? lastActionStatus,
    bool? isLoading,
  }) {
    return AppState(
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      originalTags: originalTags ?? this.originalTags,
      originalNotes: originalNotes ?? this.originalNotes,
      lastActionStatus: lastActionStatus ?? this.lastActionStatus,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  List<String>? getTags(
    int surahIndex,
    int ayaIndex,
  ) {
    String key = "${surahIndex}_$ayaIndex";

    return tags[key];
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
    return "Tags: ${originalTags.length}, Notes: ${originalNotes.length}, Status: $lastActionStatus, isLoading: $isLoading";
  }

  @override
  List<Object> get props => [
        originalTags,
        originalNotes,
        tags,
        notes,
        lastActionStatus,
        isLoading,
      ];
}
