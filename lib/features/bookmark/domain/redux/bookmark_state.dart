import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class BookmarkState extends Equatable {
  final int? suraIndex;
  final int? ayaIndex;

  const BookmarkState({
    this.suraIndex,
    this.ayaIndex,
  });

  BookmarkState copyWith({
    int? suraIndex,
    int? ayaIndex,
  }) {
    return BookmarkState(
      suraIndex: suraIndex ?? this.suraIndex,
      ayaIndex: ayaIndex ?? this.ayaIndex,
    );
  }

  @override
  List<Object?> get props => [
        suraIndex,
        ayaIndex,
      ];
}
