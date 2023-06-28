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

class AppStateResetStatusAction extends AppStateAction {}

/// Operations
///
class AppStateTagBaseAction extends AppStateAction {
  final int surahIndex;
  final int ayaIndex;
  final String tag;

  AppStateTagBaseAction({
    required this.surahIndex,
    required this.ayaIndex,
    required this.tag,
  });
}

class AppStateCreateTagAction extends AppStateTagBaseAction {
  AppStateCreateTagAction({
    required super.surahIndex,
    required super.ayaIndex,
    required super.tag,
  });
}

class AppStateAddTagAction extends AppStateTagBaseAction {
  AppStateAddTagAction({
    required super.surahIndex,
    required super.ayaIndex,
    required super.tag,
  });
}

class AppStateRemoveTagAction extends AppStateTagBaseAction {
  AppStateRemoveTagAction({
    required super.surahIndex,
    required super.ayaIndex,
    required super.tag,
  });
}

class AppStateDeleteTagAction extends AppStateTagBaseAction {
  AppStateDeleteTagAction({
    required super.surahIndex,
    required super.ayaIndex,
    required super.tag,
  });
}

/// Response
///

class AppStateFetchTagsSucceededAction extends AppStateAction {
  final List<QuranTag> fetchedTags;

  AppStateFetchTagsSucceededAction(
    this.fetchedTags,
  );
}

/// Operations
///

class AppStateModifyTagResponseBaseAction extends AppStateAction {
  final String message;

  AppStateModifyTagResponseBaseAction({
    required this.message,
  });
}

class AppStateCreateTagSucceededAction
    extends AppStateModifyTagResponseBaseAction {
  AppStateCreateTagSucceededAction({
    required super.message,
  });
}

class AppStateCreateTagFailureAction
    extends AppStateModifyTagResponseBaseAction {
  AppStateCreateTagFailureAction({
    required super.message,
  });
}

class AppStateAddTagSucceededAction
    extends AppStateModifyTagResponseBaseAction {
  AppStateAddTagSucceededAction({
    required super.message,
  });
}

class AppStateAddTagFailureAction extends AppStateModifyTagResponseBaseAction {
  AppStateAddTagFailureAction({
    required super.message,
  });
}

class AppStateRemoveTagSucceededAction
    extends AppStateModifyTagResponseBaseAction {
  AppStateRemoveTagSucceededAction({
    required super.message,
  });
}

class AppStateRemoveTagFailureAction
    extends AppStateModifyTagResponseBaseAction {
  AppStateRemoveTagFailureAction({
    required super.message,
  });
}

class AppStateDeleteTagSucceededAction
    extends AppStateModifyTagResponseBaseAction {
  AppStateDeleteTagSucceededAction({
    required super.message,
  });
}

class AppStateDeleteTagFailureAction
    extends AppStateModifyTagResponseBaseAction {
  AppStateDeleteTagFailureAction({
    required super.message,
  });
}
