import 'package:noble_quran/models/surah_title.dart';
import 'package:noble_quran/models/word.dart';

import '../../../../core/domain/app_state/redux/actions/actions.dart';

class InitializeReaderScreenAction extends AppStateAction {}

class SetSurahListAction extends AppStateAction {
  final List<NQSurahTitle> surahs;

  SetSurahListAction({
    required this.surahs,
  });

  @override
  String toString() {
    return '{action: ${super.toString()}, surahs: ${surahs.length}';
  }
}

class SelectSurahAction extends AppStateAction {
  final int surah;
  final List<List<NQWord>>? words;

  SelectSurahAction({
    required this.surah,
    this.words,
  });

  @override
  String toString() {
    return '{action: ${super.toString()}, surah: $surah, words: ${words?.length}}';
  }

  SelectSurahAction copyWith({
    int? surah,
    List<List<NQWord>>? words,
  }) {
    return SelectSurahAction(
      surah: surah ?? this.surah,
      words: words ?? this.words,
    );
  }
}

class SelectAyaAction extends AppStateAction {
  final int aya;

  SelectAyaAction({
    required this.aya,
  });

  @override
  String toString() {
    return '{action: ${super.toString()}, aya: $aya';
  }
}

class SelectParticularAyaAction extends AppStateAction {
  final int surah;
  final int aya;
  final List<List<NQWord>>? words;

  SelectParticularAyaAction({
    required this.surah,
    required this.aya,
    this.words,
  });

  SelectParticularAyaAction copyWith({
    int? surah,
    int? aya,
    List<List<NQWord>>? words,
  }) {
    return SelectParticularAyaAction(
      surah: surah ?? this.surah,
      aya: aya ?? this.aya,
      words: words ?? this.words,
    );
  }

  @override
  String toString() {
    return '{action: ${super.toString()}, surah: $surah, aya: $aya, words len: ${words?.length}';
  }
}

class IncreaseFontSizeAction extends AppStateAction {}

class DecreaseFontSizeAction extends AppStateAction {}

class ResetFontSizeAction extends AppStateAction {}

class ShowLoadingAction extends AppStateAction {}

class HideLoadingAction extends AppStateAction {}

class SetAudioContinuousPlayMode extends AppStateAction {
  final bool isEnabled;

  SetAudioContinuousPlayMode({
    required this.isEnabled,
  });

  @override
  String toString() {
    return '{action: ${super.toString()}, isEnabled: $isEnabled';
  }
}

class NextAyaAction extends AppStateAction {}

class PreviousAyaAction extends AppStateAction {}

class ShareAyaAction extends AppStateAction {}

class RandomAyaAction extends AppStateAction {}
