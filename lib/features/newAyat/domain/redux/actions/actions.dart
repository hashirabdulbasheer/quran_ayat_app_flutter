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

class IncreaseFontSizeAction extends AppStateAction {}

class DecreaseFontSizeAction extends AppStateAction {}

class ResetFontSizeAction extends AppStateAction {}

class ShowLoadingAction extends AppStateAction {}

class HideLoadingAction extends AppStateAction {}
