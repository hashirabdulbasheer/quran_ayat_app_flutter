import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../models/quran_answer.dart';
import '../models/quran_question.dart';

@immutable
class ChallengeScreenState extends Equatable {
  final List<QuranQuestion> questions;
  final int currentIndex;
  final bool isLoading;

  const ChallengeScreenState({
    this.questions = const [],
    this.currentIndex = 0,
    this.isLoading = false,
  });

  ChallengeScreenState copyWith({
    List<QuranQuestion>? questions,
    int? currentIndex,
    bool? isLoading,
  }) {
    return ChallengeScreenState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  List<QuranAnswer> currentQuestionAnswers() {
    return questions[currentIndex].answers;
  }

  @override
  List<Object?> get props => [
        questions,
        currentIndex,
        isLoading,
      ];
}
