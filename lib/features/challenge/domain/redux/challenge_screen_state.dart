import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../models/qr_user_model.dart';
import '../../../home/presentation/quran_home_screen.dart';
import '../enums/quran_answer_status_enum.dart';
import '../models/quran_answer.dart';
import '../models/quran_question.dart';

@immutable
class ChallengeScreenState extends Equatable {
  final List<QuranQuestion> allQuestions;
  final QuranHomeScreenBottomTabsEnum selectedHomeScreenTab;
  final int currentIndex;
  final bool isLoading;

  const ChallengeScreenState({
    this.allQuestions = const [],
    this.selectedHomeScreenTab = QuranHomeScreenBottomTabsEnum.reader,
    this.currentIndex = 0,
    this.isLoading = false,
  });

  ChallengeScreenState copyWith({
    List<QuranQuestion>? allQuestions,
    QuranHomeScreenBottomTabsEnum? selectedHomeScreenTab,
    int? currentIndex,
    bool? isLoading,
  }) {
    return ChallengeScreenState(
      allQuestions: allQuestions ?? this.allQuestions,
      selectedHomeScreenTab:
          selectedHomeScreenTab ?? this.selectedHomeScreenTab,
      currentIndex: currentIndex ?? this.currentIndex,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  int indexFromQuestionId(int questionId) {
    return allQuestions.indexWhere((element) => element.id == questionId);
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
      (element) =>
          element.status == QuranAnswerStatusEnum.approved ||
          element.status == QuranAnswerStatusEnum.reported,
    );
  }

  List<QuranAnswer> approvedAnswersForQuestion(QuranQuestion question) {
    return question.answers
        .where(
          (element) =>
              element.status == QuranAnswerStatusEnum.approved ||
              element.status == QuranAnswerStatusEnum.reported,
        )
        .toList();
  }

  List<QuranQuestion> _filterQuestionsBasedOn(
    bool Function(QuranAnswer element) answerCondition,
  ) {
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
      filteredQuestions.add(
        question.copyWith(answers: answers),
      );
    }
    // oldest on top
    filteredQuestions.sort((
      a,
      b,
    ) =>
        a.createdOn.compareTo(b.createdOn));

    return filteredQuestions;
  }

  @override
  List<Object?> get props => [
        allQuestions,
        selectedHomeScreenTab,
        currentIndex,
        isLoading,
      ];
}
