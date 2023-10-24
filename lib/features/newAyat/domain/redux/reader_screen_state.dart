import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:noble_quran/models/surah_title.dart';

import '../../../bookmark/domain/redux/bookmark_state.dart';

@immutable
class ReaderScreenState extends Equatable {
  final List<NQSurahTitle> surahTitles;
  final int currentSurah;
  final int currentAya;
  final bool isAudioContinuousModeEnabled;
  final bool isLoading;
  final BookmarkState bookmarkState;

  const ReaderScreenState({
    this.surahTitles = const [],
    this.currentSurah = 1,
    this.currentAya = 1,
    this.isAudioContinuousModeEnabled = false,
    this.isLoading = false,
    this.bookmarkState = const BookmarkState(),
  });

  ReaderScreenState copyWith({
    List<NQSurahTitle>? surahTitles,
    int? currentSurah,
    int? currentAya,
    bool? isAudioContinuousModeEnabled,
    bool? isLoading,
    BookmarkState? bookmarkState,
  }) {
    return ReaderScreenState(
      surahTitles: surahTitles ?? this.surahTitles,
      currentSurah: currentSurah ?? this.currentSurah,
      currentAya: currentAya ?? this.currentAya,
      isLoading: isLoading ?? this.isLoading,
      isAudioContinuousModeEnabled:
          isAudioContinuousModeEnabled ?? this.isAudioContinuousModeEnabled,
      bookmarkState: bookmarkState ?? this.bookmarkState,
    );
  }

  NQSurahTitle currentSurahDetails() {
    if (surahTitles.isEmpty) {
      return NQSurahTitle.defaultValue();
    }

    return surahTitles[currentSurah];
  }

  @override
  String toString() {
    return "surah: $currentSurah, aya: $currentAya, titles: ${surahTitles.length}, isLoading: $isAudioContinuousModeEnabled, isAudioContinuousModeEnabled: $isLoading, bookmark: ${bookmarkState.toString()}";
  }

  @override
  List<Object> get props => [
        surahTitles,
        isLoading,
        currentSurah,
        currentAya,
        isAudioContinuousModeEnabled,
        bookmarkState,
      ];
}
