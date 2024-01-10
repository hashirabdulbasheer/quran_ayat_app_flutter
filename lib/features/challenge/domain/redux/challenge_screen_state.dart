import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../models/quran_question.dart';

@immutable
class ChallengeScreenState extends Equatable {
  final List<QuranQuestion> allQuestions;
  final List<QuranQuestion> filteredQuestions;
  final int currentIndex;
  final bool isLoading;

  const ChallengeScreenState({
    this.allQuestions = const [],
    this.filteredQuestions = const [],
    this.currentIndex = 0,
    this.isLoading = false,
  });

  ChallengeScreenState copyWith({
    List<QuranQuestion>? allQuestions,
    List<QuranQuestion>? filteredQuestions,
    int? currentIndex,
    bool? isLoading,
  }) {
    return ChallengeScreenState(
      allQuestions: allQuestions ?? this.allQuestions,
      filteredQuestions: filteredQuestions ?? this.filteredQuestions,
      currentIndex: currentIndex ?? this.currentIndex,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  QuranQuestion? get currentQuestion => filteredQuestions.length > currentIndex
      ? filteredQuestions[currentIndex]
      : null;

  @override
  List<Object?> get props => [
        allQuestions,
        filteredQuestions,
        currentIndex,
        isLoading,
      ];
}
