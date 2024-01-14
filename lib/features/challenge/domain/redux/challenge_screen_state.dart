import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quran_ayat/features/challenge/domain/enums/quran_answer_status_enum.dart';

import '../../../../models/qr_user_model.dart';
import '../models/quran_answer.dart';
import '../models/quran_question.dart';

@immutable
class ChallengeScreenState extends Equatable {
  final List<QuranQuestion> allQuestions;
  final int currentIndex;
  final bool isLoading;

  const ChallengeScreenState({
    this.allQuestions = const [],
    this.currentIndex = 0,
    this.isLoading = false,
  });

  ChallengeScreenState copyWith({
    List<QuranQuestion>? allQuestions,
    int? currentIndex,
    bool? isLoading,
  }) {
    return ChallengeScreenState(
      allQuestions: allQuestions ?? this.allQuestions,
      currentIndex: currentIndex ?? this.currentIndex,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  QuranQuestion? currentQuestionForDisplay() {
    List<QuranQuestion> approved = allApprovedAnswers();

    return approved.length > currentIndex
        ? allApprovedAnswers()[currentIndex]
        : null;
  }

  // questions submitted by the logged in user
  List<QuranQuestion> userSubmittedQuestions(QuranUser user) {
    return _filterQuestionsBasedOn((element) => element.userId == user.uid);
  }

  // questions with approved answers
  List<QuranQuestion> allApprovedAnswers() {
    return _filterQuestionsBasedOn(
        (element) => element.status == QuranAnswerStatusEnum.approved);
  }

  List<QuranQuestion> _filterQuestionsBasedOn(
      bool Function(QuranAnswer element) answerCondition) {
    List<QuranQuestion> questions = List.from(allQuestions);
    List<QuranQuestion> filteredQuestions = [];
    for (QuranQuestion question in questions) {
      List<QuranAnswer> answers = question.answers
          .where((element) => answerCondition(element))
          .toList();
      // latest on top
      answers.sort((
        a,
        b,
      ) =>
          b.createdOn.compareTo(a.createdOn));
      if (answers.isNotEmpty) {
        filteredQuestions.add(
          question.copyWith(answers: answers),
        );
      }
    }
    // latest on top
    filteredQuestions.sort((
      a,
      b,
    ) =>
        b.createdOn.compareTo(a.createdOn));

    return filteredQuestions;
  }

  @override
  List<Object?> get props => [
        allQuestions,
        currentIndex,
        isLoading,
      ];
}
