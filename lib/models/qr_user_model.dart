import 'package:equatable/equatable.dart';

class QuranUser extends Equatable {
  final String name;
  final String email;
  final String uid;

  const QuranUser({
    required this.name,
    required this.email,
    required this.uid,
  });

  QuranUser copyWith({
    String? name,
    String? email,
    String? uid,
    bool? isAdmin,
  }) {
    return QuranUser(
      name: name ?? this.name,
      email: email ?? this.email,
      uid: uid ?? this.uid,
    );
  }

  @override
  List<Object?> get props => [
        name,
        email,
        uid,
      ];
}
