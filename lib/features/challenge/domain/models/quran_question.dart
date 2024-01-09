import 'package:equatable/equatable.dart';

import '../enums/quran_question_status_enum.dart';
import 'quran_answer.dart';

class QuranQuestion extends Equatable {
  String id;
  String question;
  List<QuranAnswer> answers;
  QuranQuestionStatusEnum status;
  int createdOn;

  QuranQuestion({
    required this.id,
    required this.question,
    required this.answers,
    required this.status,
    required this.createdOn,
  });

  @override
  String toString() {
    return 'QuranQuestion{id: $id, question: $question, answers: ${answers
        .length}, status: $status, createdOn: $createdOn}';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "question": question,
      "answers": answers.map((e) => e.toMap()).toList(),
      "createdOn": createdOn,
      "status": status.rawString(),
    };
  }

  @override
  List<Object?> get props =>
      [
        id,
        question,
        answers,
        status,
        createdOn,
      ];

}
