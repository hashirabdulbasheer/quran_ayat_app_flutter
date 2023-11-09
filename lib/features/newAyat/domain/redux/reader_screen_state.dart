import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:noble_quran/models/surah_title.dart';
import 'package:quran_ayat/features/newAyat/data/quran_data.dart';
import 'package:quran_ayat/features/newAyat/data/surah_index.dart';

typedef BookmarkState = SurahIndex;

@immutable
class ReaderScreenState extends Equatable {
  final List<NQSurahTitle> surahTitles;
  final SurahIndex currentIndex;
  final bool isAudioContinuousModeEnabled;
  final bool isLoading;
  final BookmarkState? bookmarkState;
  final QuranData data;

  const ReaderScreenState({
    this.surahTitles = const [],
    this.currentIndex = SurahIndex.defaultIndex,
    this.isAudioContinuousModeEnabled = false,
    this.isLoading = false,
    this.bookmarkState,
    this.data = const QuranData(),
  });

  ReaderScreenState copyWith({
    List<NQSurahTitle>? surahTitles,
    SurahIndex? currentIndex,
    bool? isAudioContinuousModeEnabled,
    bool? isLoading,
    BookmarkState? bookmarkState,
    QuranData? data,
  }) {
    return ReaderScreenState(
      surahTitles: surahTitles ?? this.surahTitles,
      currentIndex: currentIndex ?? this.currentIndex,
      isLoading: isLoading ?? this.isLoading,
      isAudioContinuousModeEnabled:
          isAudioContinuousModeEnabled ?? this.isAudioContinuousModeEnabled,
      bookmarkState: bookmarkState ?? this.bookmarkState,
      data: data ?? this.data,
    );
  }

  NQSurahTitle currentSurahDetails() {
    if (surahTitles.isEmpty) {
      return NQSurahTitle.defaultValue();
    }

    return surahTitles[currentIndex.sura];
  }

  @override
  String toString() {
    return "{surah: ${currentIndex.toString()}, titles: ${surahTitles.length}, "
        "isLoading: $isAudioContinuousModeEnabled, isAudioContinuousModeEnabled: $isLoading, "
        "bookmark: ${bookmarkState.toString()}, suraWords Len: ${data.words?.length}, "
        "translation: ${data.translation?.name}}";
  }

  @override
  List<Object?> get props => [
        surahTitles,
        isLoading,
        currentIndex,
        isAudioContinuousModeEnabled,
        bookmarkState,
        data,
      ];
}
