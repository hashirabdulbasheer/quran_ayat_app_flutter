import 'package:equatable/equatable.dart';

import '../enums/quran_question_status_enum.dart';
import 'quran_answer.dart';

class QuranQuestion extends Equatable {
  final int id;
  final String title;
  final String question;
  final List<QuranAnswer> answers;
  final QuranQuestionStatusEnum status;
  final int createdOn;

  const QuranQuestion({
    required this.id,
    required this.title,
    required this.question,
    required this.answers,
    required this.status,
    required this.createdOn,
  });

  QuranQuestion copyWith({
    int? id,
    String? title,
    String? question,
    List<QuranAnswer>? answers,
    QuranQuestionStatusEnum? status,
    int? createdOn,
  }) {
    return QuranQuestion(
      id: id ?? this.id,
      title: title ?? this.title,
      question: question ?? this.question,
      answers: answers ?? this.answers,
      status: status ?? this.status,
      createdOn: createdOn ?? this.createdOn,
    );
  }

  @override
  String toString() {
    return 'QuranQuestion{id: $id, title: $title, question: $question, answers: ${answers.length}, status: $status, createdOn: $createdOn}';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "title": title,
      "question": question,
      "answers": answers.map((e) => e.toMap()).toList(),
      "createdOn": createdOn,
      "status": status.rawString(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        question,
        answers,
        status,
        createdOn,
      ];
}
