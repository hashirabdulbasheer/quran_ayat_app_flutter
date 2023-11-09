import 'package:equatable/equatable.dart';

class SurahIndex extends Equatable {
  final int _sura;
  final int _aya;

  const SurahIndex(
    this._sura,
    this._aya,
  );

  // index used inside the app
  SurahIndex internalIndex() {
    return SurahIndex(
      _sura - 1,
      _aya,
    );
  }

  // index exposed to outside world
  SurahIndex externalIndex() {
    return SurahIndex(
      _sura,
      _aya,
    );
  }

  @override
  List<Object?> get props => [
        _sura,
        _aya,
      ];
}
