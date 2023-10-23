import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../bookmarks_manager.dart';

@immutable
class BookmarkState extends Equatable {
  final QuranBookmarksManager bookmarksManager;
  final int? suraIndex;
  final int? ayaIndex;

  const BookmarkState({
    required this.bookmarksManager,
    this.suraIndex,
    this.ayaIndex,
  });

  @override
  List<Object?> get props => [
        bookmarksManager,
        suraIndex,
        ayaIndex,
      ];
}
