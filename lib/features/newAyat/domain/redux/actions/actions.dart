import 'package:noble_quran/models/surah_title.dart';

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

  SelectSurahAction({
    required this.surah,
  });

  @override
  String toString() {
    return '{action: ${super.toString()}, surah: $surah';
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
  final int sura;
  final int aya;

  SelectParticularAyaAction({
    required this.sura,
    required this.aya,
  });

  @override
  String toString() {
    return '{action: ${super.toString()}, sura: $sura, aya: $aya';
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
