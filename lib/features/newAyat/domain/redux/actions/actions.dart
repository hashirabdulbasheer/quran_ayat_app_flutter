import 'package:noble_quran/models/surah_title.dart';

import '../../../../core/domain/app_state/redux/actions/actions.dart';
import '../../../data/quran_data.dart';
import '../../../data/surah_index.dart';

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
  final SurahIndex index;
  final QuranData? data;

  SelectSurahAction({
    required this.index,
    this.data,
  });

  @override
  String toString() {
    return '{action: ${super.toString()}, surah: $index, data: ${data?.toString()}';
  }

  SelectSurahAction copyWith({
    SurahIndex? index,
    QuranData? data,
  }) {
    return SelectSurahAction(
      index: index ?? this.index,
      data: data ?? this.data,
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
  final SurahIndex index;
  final QuranData? data;

  SelectParticularAyaAction({
    required this.index,
    this.data,
  });

  SelectParticularAyaAction copyWith({
    SurahIndex? index,
    QuranData? data,
  }) {
    return SelectParticularAyaAction(
      index: index ?? this.index,
      data: data ?? this.data,
    );
  }

  @override
  String toString() {
    return '{action: ${super.toString()}, surah: $index, data: ${data?.toString()}';
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

class ToggleHeaderVisibilityAction extends AppStateAction {}
