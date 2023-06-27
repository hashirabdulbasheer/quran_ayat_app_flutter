import '../../../../../tags/domain/entities/quran_tag.dart';
import 'actions.dart';

/// TAG ACTIONS
///
class AppStateFetchTagsAction extends AppStateAction {}

class AppStateLoadingAction extends AppStateAction {
  final bool isLoading;

  AppStateLoadingAction({
    required this.isLoading,
  });
}

class AppStateModifyTagAction extends AppStateAction {
  final int surahIndex;
  final int ayaIndex;
  final String tag;
  final AppStateTagModifyAction action;

  AppStateModifyTagAction({
    required this.surahIndex,
    required this.ayaIndex,
    required this.tag,
    required this.action,
  });
}

class AppStateFetchTagsSucceededAction extends AppStateAction {
  final List<QuranTag> fetchedTags;

  AppStateFetchTagsSucceededAction(
      this.fetchedTags,
      );
}

class AppStateModifyTagSucceededAction extends AppStateAction {}

class AppStateModifyTagFailureAction extends AppStateAction {
  final String message;

  AppStateModifyTagFailureAction({
    required this.message,
  });
}
