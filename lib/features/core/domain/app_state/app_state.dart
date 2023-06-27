import 'package:flutter/material.dart';
import '../../../notes/domain/entities/quran_note.dart';
import '../../../tags/domain/entities/quran_tag.dart';

export "redux/reducers/reducer.dart";
export "redux/middleware/middleware.dart";
export "redux/actions/actions.dart";

/// STATE
///
@immutable
class AppState {
  final List<QuranTag> originalTags;
  final List<QuranNote> originalNotes;
  final Map<String, List<String>> tags;
  final Map<String, List<QuranNote>> notes;
  final StateError? error;
  final bool isLoading;

  const AppState({
    this.tags = const {},
    this.notes = const {},
    this.originalTags = const [],
    this.originalNotes = const [],
    this.error,
    this.isLoading = false,
  });

  AppState copyWith({
    List<QuranTag>? originalTags,
    List<QuranNote>? originalNotes,
    Map<String, List<String>>? tags,
    Map<String, List<QuranNote>>? notes,
    StateError? error,
    bool? isLoading,
  }) {
    return AppState(
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      originalTags: originalTags ?? this.originalTags,
      originalNotes: originalNotes ?? this.originalNotes,
      error: error ?? this.error,
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
    return "Tags: ${originalTags.length}, Notes: ${originalNotes.length}, Error: $error, isLoading: $isLoading";
  }
}
