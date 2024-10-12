import 'package:ayat_app/src/domain/models/domain_models.dart';

class QPageData extends Equatable {
  final List<List<QWord>> ayaWords;
  final List<QAya> transliterations;
  final List<(QTranslation, List<QAya>)> translations;
  final QPage page;
  final SurahIndex? selectedIndex;
  final bool scrollReachedTop;

  const QPageData({
    required this.ayaWords,
    required this.transliterations,
    required this.translations,
    required this.page,
    this.selectedIndex,
    this.scrollReachedTop = false,
  });

  QPageData copyWith({
    SurahIndex? selectedIndex,
    SurahIndex? bookmarkIndex,
    bool? scrollReachedTop,
  }) {
    return QPageData(
      ayaWords: ayaWords,
      transliterations: transliterations,
      translations: translations,
      page: page,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      scrollReachedTop: scrollReachedTop ?? this.scrollReachedTop,
    );
  }

  @override
  List<Object?> get props => [
        ayaWords,
        transliterations,
        translations,
        page,
        selectedIndex,
        scrollReachedTop,
      ];
}
