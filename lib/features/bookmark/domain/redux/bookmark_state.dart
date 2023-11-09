import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../newAyat/data/surah_index.dart';

@immutable
class BookmarkState extends Equatable {
  final SurahIndex? index;

  const BookmarkState({
    this.index,
  });

  BookmarkState copyWith({
    SurahIndex? index,
  }) {
    return BookmarkState(
      index: index ?? this.index,
    );
  }

  @override
  List<Object?> get props => [
        index,
      ];
}
