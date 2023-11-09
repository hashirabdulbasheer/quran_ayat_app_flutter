import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../newAyat/data/surah_index.dart';

@immutable
class BookmarkState1 extends Equatable {
  final SurahIndex? index;

  const BookmarkState1({
    this.index,
  });

  BookmarkState1 copyWith({
    SurahIndex? index,
  }) {
    return BookmarkState1(
      index: index ?? this.index,
    );
  }

  @override
  List<Object?> get props => [
        index,
      ];
}
