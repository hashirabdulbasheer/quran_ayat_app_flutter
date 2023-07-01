import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../../../notes/domain/redux/notes_state.dart';
import '../../../tags/domain/redux/tag_state.dart';
import 'redux/actions/actions.dart';
export "redux/reducers/reducer.dart";
export "redux/middleware/middleware.dart";
export "redux/actions/actions.dart";

/// STATE
///
@immutable
class AppState extends Equatable {
  final TagState tags;
  final NotesState notes;
  final AppStateActionStatus lastActionStatus;
  final bool isLoading;

  const AppState({
    this.tags = const TagState(),
    this.notes = const NotesState(),
    this.lastActionStatus = const AppStateActionStatus(
      action: "",
      message: "",
    ),
    this.isLoading = false,
  });

  AppState copyWith({
    TagState? tags,
    NotesState? notes,
    AppStateActionStatus? lastActionStatus,
    bool? isLoading,
  }) {
    return AppState(
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      lastActionStatus: lastActionStatus ?? this.lastActionStatus,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  String toString() {
    return "Tags: ${tags.toString()}, Notes: ${notes.toString()}, Status: $lastActionStatus, isLoading: $isLoading";
  }

  @override
  List<Object> get props => [
        tags,
        notes,
        lastActionStatus,
        isLoading,
      ];
}
