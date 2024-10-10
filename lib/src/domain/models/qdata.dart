import 'package:ayat_app/src/domain/models/domain_models.dart';

class QPageData extends Equatable {
  final List<List<QWord>> ayaWords;
  final List<QAya> transliterations;
  final List<(QTranslation, List<QAya>)> translations;
  final QPage page;
  final SurahIndex? selectedIndex;
  final SurahIndex? bookmarkIndex;

  const QPageData({
    required this.ayaWords,
    required this.transliterations,
    required this.translations,
    required this.page,
    this.selectedIndex,
    this.bookmarkIndex,
  });

  QPageData copyWith({
    SurahIndex? selectedIndex,
    SurahIndex? bookmarkIndex,
  }) {
    return QPageData(
      ayaWords: ayaWords,
      transliterations: transliterations,
      translations: translations,
      page: page,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      bookmarkIndex: bookmarkIndex ?? this.bookmarkIndex,
    );
  }

  @override
  List<Object?> get props => [
        ayaWords,
        transliterations,
        translations,
        page,
        selectedIndex,
        bookmarkIndex,
      ];
}
