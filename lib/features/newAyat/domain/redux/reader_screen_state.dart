import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:noble_quran/enums/translations.dart';
import 'package:noble_quran/models/surah_title.dart';
import 'package:noble_quran/models/word.dart';
import 'package:quran_ayat/features/ai/domain/ai_type_enum.dart';

import '../../data/quran_data.dart';
import '../../data/surah_index.dart';

typedef BookmarkState = SurahIndex;

@immutable
class ReaderScreenState extends Equatable {
  final List<NQSurahTitle> surahTitles;
  final SurahIndex currentIndex;
  final bool isLoading;
  final bool isHeaderVisible;
  final Map<QuranAIType, bool> aiResponseVisibility;
  final BookmarkState? bookmarkState;
  final QuranData data;

  const ReaderScreenState({
    this.surahTitles = const [],
    this.currentIndex = SurahIndex.defaultIndex,
    this.isLoading = false,
    this.isHeaderVisible = false,
    this.aiResponseVisibility = const {},
    this.bookmarkState,
    this.data = const QuranData(),
  });

  ReaderScreenState copyWith({
    List<NQSurahTitle>? surahTitles,
    SurahIndex? currentIndex,
    bool? isLoading,
    bool? isHeaderVisible,
    Map<QuranAIType, bool>? aiResponseVisibility,
    BookmarkState? bookmarkState,
    QuranData? data,
  }) {
    return ReaderScreenState(
      surahTitles: surahTitles ?? this.surahTitles,
      currentIndex: currentIndex ?? this.currentIndex,
      isLoading: isLoading ?? this.isLoading,
      isHeaderVisible: isHeaderVisible ?? this.isHeaderVisible,
      aiResponseVisibility: aiResponseVisibility ?? this.aiResponseVisibility,
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

  Map<NQTranslation, String> currentTranslations() {
    Map<NQTranslation, String> translations = {};
    data.translationMap.forEach((
      key,
      value,
    ) {
      translations[key] = value?.aya[currentIndex.aya].text ?? "";
    });

    return translations;
  }

  String? currentTransliteration() =>
      data.transliteration?.aya[currentIndex.aya].text;

  List<NQWord> currentAyaWords() =>
      data.words.isNotEmpty ? data.words[currentIndex.aya] : [];

  bool isBismillahDisplayed() {
    return currentIndex.aya == 0 &&
        currentIndex.sura != 0 &&
        currentIndex.sura != 8;
  }

  @override
  String toString() {
    return "{surah: ${currentIndex.toString()}, titles: ${surahTitles.length}, "
        "isLoading: $isLoading,"
        "aiVisibility: $aiResponseVisibility,"
        "bookmark: ${bookmarkState.toString()}, suraWords Len: ${data.words.length}, "
        "translation len: ${data.translationMap.keys.length}, transliteration: ${data.transliteration?.name}}";
  }

  @override
  List<Object?> get props => [
        surahTitles,
        isLoading,
        isHeaderVisible,
        currentIndex,
        bookmarkState,
        aiResponseVisibility,
        data,
      ];
}
