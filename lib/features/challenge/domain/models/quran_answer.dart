import 'package:equatable/equatable.dart';

import '../enums/quran_answer_status_enum.dart';

class QuranAnswer extends Equatable {
  final String id;
  final int surah;
  final int aya;
  final String userId;
  final String username;
  final String note;
  final List<String> likedUsers;
  final int createdOn;
  final QuranAnswerStatusEnum status;

  const QuranAnswer({
    this.id = "",
    this.surah = 0,
    this.aya = 0,
    this.userId = "",
    this.username = "",
    this.note = "",
    this.likedUsers = const [],
    this.createdOn = 0,
    this.status = QuranAnswerStatusEnum.undefined,
  });

  QuranAnswer copyWith({
    String? id,
    int? surah,
    int? aya,
    String? userId,
    String? username,
    String? note,
    List<String>? likedUsers,
    int? createdOn,
    QuranAnswerStatusEnum? status,
  }) {
    return QuranAnswer(
      id: id ?? this.id,
      surah: surah ?? this.surah,
      aya: aya ?? this.aya,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      likedUsers: likedUsers ?? this.likedUsers,
      note: note ?? this.note,
      createdOn: createdOn ?? this.createdOn,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'QuranAnswer{id: $id, note: $note, numLikes: ${likedUsers.length}, surah: $surah, aya: $aya, '
        'userId: $userId, username: $username, createdOn: $createdOn, '
        'status: $status}';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "surah": surah,
      "aya": aya,
      "userId": userId,
      "username": username,
      "note": note,
      "likedUsers": likedUsers,
      "createdOn": createdOn,
      "status": status.rawString(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        surah,
        aya,
        userId,
        username,
        note,
        likedUsers,
        createdOn,
        status,
      ];
}
