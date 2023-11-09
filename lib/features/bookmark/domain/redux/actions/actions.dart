import '../../../../core/domain/app_state/redux/actions/actions.dart';

// Saves bookmark to local and remote
class SaveBookmarkAction extends AppStateAction {
  final int surahIndex;
  final int ayaIndex;

  SaveBookmarkAction({
    required this.surahIndex,
    required this.ayaIndex,
  });

  @override
  String toString() {
    return '{action: ${super.toString()}, surahIndex: $surahIndex, ayaIndex: $ayaIndex';
  }
}

class InitBookmarkAction extends AppStateAction {
  final int? surahIndex;
  final int? ayaIndex;

  InitBookmarkAction({
    this.surahIndex,
    this.ayaIndex,
  });

  InitBookmarkAction copyWith({
    int? surahIndex,
    int? ayaIndex,
  }) {
    return InitBookmarkAction(
      surahIndex: surahIndex ?? this.surahIndex,
      ayaIndex: ayaIndex ?? this.ayaIndex,
    );
  }

  @override
  String toString() {
    return '{action: ${super.toString()}, surahIndex: $surahIndex, ayaIndex: $ayaIndex';
  }
}
