import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:quran_ayat/misc/enums/quran_app_mode_enum.dart';
import 'package:quran_ayat/models/qr_user_model.dart';

import '../../../challenge/domain/redux/challenge_screen_state.dart';
import '../../../newAyat/domain/redux/reader_screen_state.dart';
import '../../../notes/domain/redux/notes_state.dart';
import '../../../tags/domain/redux/tag_state.dart';
import 'redux/actions/actions.dart';

export "redux/actions/actions.dart";
export "redux/middleware/middleware.dart";
export "redux/reducers/reducer.dart";

/// STATE
///
@immutable
class AppState extends Equatable {
  final QuranUser? user;
  final TagState tags;
  final NotesState notes;
  final ReaderScreenState reader;
  final ChallengeScreenState challenge;
  final AppStateActionStatus lastActionStatus;
  final QuranAppMode appMode;
  final bool isLoading;

  const AppState({
    this.user,
    this.tags = const TagState(),
    this.notes = const NotesState(),
    this.reader = const ReaderScreenState(),
    this.challenge = const ChallengeScreenState(),
    this.lastActionStatus = const AppStateActionStatus(
      action: "",
      message: "",
    ),
    this.appMode = QuranAppMode.basic,
    this.isLoading = false,
  });

  AppState copyWith({
    QuranUser? user,
    TagState? tags,
    NotesState? notes,
    ReaderScreenState? reader,
    ChallengeScreenState? challenge,
    AppStateActionStatus? lastActionStatus,
    QuranAppMode? appMode,
    bool? isLoading,
  }) {
    return AppState(
      user: user ?? this.user,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      reader: reader ?? this.reader,
      challenge: challenge ?? this.challenge,
      lastActionStatus: lastActionStatus ?? this.lastActionStatus,
      appMode: appMode ?? this.appMode,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  String toString() {
    return "User: ${user?.uid}, Tags: ${tags.toString()}, Notes: ${notes.toString()}, "
        "Reader: ${reader.toString()}, Challenge: ${challenge.toString()}, "
        "Status: $lastActionStatus, appMode: ${appMode.rawString()}, isLoading: $isLoading";
  }

  @override
  List<Object?> get props => [
        user,
        tags,
        notes,
        reader,
        challenge,
        lastActionStatus,
        appMode,
        isLoading,
      ];
}
