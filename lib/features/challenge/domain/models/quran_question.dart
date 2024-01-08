import 'package:equatable/equatable.dart';

import '../enums/quran_question_status_enum.dart';
import '../interfaces/quran_challenge_interface.dart';

class QuranQuestion extends Equatable {
  String id;
  String question;
  List<QuranAnswer> answers;
  QuranQuestionStatusEnum status;

  QuranQuestion({
    required this.id,
    required this.question,
    required this.answers,
    required this.status,
  });

  @override
  String toString() {
    return 'QuranQuestion{id: $id, question: $question, answers: ${answers
        .length}, status: $status}';
  }

  @override
  List<Object?> get props =>
      [
        id,
        question,
        answers,
        status,
      ];

  ;

}
