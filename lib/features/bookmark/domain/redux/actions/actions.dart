import '../../../../core/domain/app_state/redux/actions/actions.dart';
import '../../../../newAyat/data/surah_index.dart';

// Saves bookmark to local and remote
class SaveBookmarkAction extends AppStateAction {
  final SurahIndex index;

  SaveBookmarkAction({
    required this.index,
  });

  @override
  String toString() {
    return '{action: ${super.toString()}, surahIndex: ${index.toString()}}';
  }
}

class InitBookmarkAction extends AppStateAction {
  final SurahIndex? index;

  InitBookmarkAction({
    this.index,
  });

  InitBookmarkAction copyWith({
    SurahIndex? index,
  }) {
    return InitBookmarkAction(
      index: index ?? this.index,
    );
  }

  @override
  String toString() {
    return '{action: ${super.toString()}, surahIndex: ${index.toString()}}';
  }
}
