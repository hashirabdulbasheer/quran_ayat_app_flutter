import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../core/domain/app_state/redux/actions/actions.dart';
import '../entities/quran_tag.dart';

@immutable
class TagState extends Equatable {
  final List<QuranTag> originalTags;
  final Map<String, List<String>> tags;
  final AppStateActionStatus lastActionStatus;
  final bool isLoading;

  const TagState({
    this.originalTags = const [],
    this.tags = const {},
    this.lastActionStatus = const AppStateActionStatus(
      action: "",
      message: "",
    ),
    this.isLoading = false,
  });

  TagState copyWith({
    List<QuranTag>? originalTags,
    Map<String, List<String>>? tags,
    AppStateActionStatus? lastActionStatus,
    bool? isLoading,
  }) {
    return TagState(
      originalTags: originalTags ?? this.originalTags,
      tags: tags ?? this.tags,
      lastActionStatus: lastActionStatus ?? this.lastActionStatus,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  List<String>? getTags(
    int surahIndex,
    int ayaIndex,
  ) {
    String key = "${surahIndex}_$ayaIndex";

    return tags[key];
  }

  @override
  String toString() {
    return 'TagOperationsState{originalTags: ${originalTags.length}, lastActionStatus: $lastActionStatus, isLoading: $isLoading}';
  }

  @override
  List<Object> get props => [
        originalTags,
        tags,
        lastActionStatus,
        isLoading,
      ];
}
