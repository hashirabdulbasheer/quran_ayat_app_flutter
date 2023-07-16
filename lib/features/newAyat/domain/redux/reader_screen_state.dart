import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:noble_quran/models/surah_title.dart';

@immutable
class ReaderScreenState extends Equatable {
  final List<NQSurahTitle> surahTitles;
  final int currentSurah;
  final int currentAya;
  final bool isAudioContinuousModeEnabled;
  final bool isLoading;

  const ReaderScreenState({
    this.surahTitles = const [],
    this.isLoading = false,
    this.isAudioContinuousModeEnabled = false,
    this.currentSurah = 1,
    this.currentAya = 1,
  });

  ReaderScreenState copyWith({
    List<NQSurahTitle>? surahTitles,
    int? currentSurah,
    int? currentAya,
    bool? isAudioContinuousModeEnabled,
    bool? isLoading,
  }) {
    return ReaderScreenState(
      surahTitles: surahTitles ?? this.surahTitles,
      currentSurah: currentSurah ?? this.currentSurah,
      currentAya: currentAya ?? this.currentAya,
      isLoading: isLoading ?? this.isLoading,
      isAudioContinuousModeEnabled:
          isAudioContinuousModeEnabled ?? this.isAudioContinuousModeEnabled,
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
    return "surah: $currentSurah, aya: $currentAya, titles: ${surahTitles.length}, isLoading: $isAudioContinuousModeEnabled, isAudioContinuousModeEnabled: $isLoading";
  }

  @override
  List<Object> get props => [
        surahTitles,
        isLoading,
        currentSurah,
        currentAya,
        isAudioContinuousModeEnabled,
      ];
}
