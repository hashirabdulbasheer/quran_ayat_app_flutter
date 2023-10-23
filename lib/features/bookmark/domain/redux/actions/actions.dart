import '../../../../core/domain/app_state/redux/actions/actions.dart';

class UpdateBookmarkAction extends AppStateAction {
  final int? surahIndex;
  final int? ayaIndex;

  UpdateBookmarkAction({
    required this.surahIndex,
    required this.ayaIndex,
  });

  @override
  String toString() {
    return '{action: ${super.toString()}, surahIndex: $surahIndex, ayaIndex: $ayaIndex';
  }
}
