import '../../../../core/domain/app_state/redux/actions/actions.dart';
import '../../entities/quran_tag.dart';

class InitializeTagsAction extends AppStateAction {}

class FetchTagsAction extends AppStateAction {}

class FetchTagsSucceededAction extends AppStateAction {
  final List<QuranTag> fetchedTags;

  FetchTagsSucceededAction(
      this.fetchedTags,
      );
}

class TagBaseAction extends AppStateAction {
  final int surahIndex;
  final int ayaIndex;
  final String tag;

  TagBaseAction({
    required this.surahIndex,
    required this.ayaIndex,
    required this.tag,
  });
}

class ModifyTagResponseBaseAction extends AppStateAction {
  final String message;

  ModifyTagResponseBaseAction({
    required this.message,
  });
}

class AddTagAction extends TagBaseAction {
  AddTagAction({
    required super.surahIndex,
    required super.ayaIndex,
    required super.tag,
  });
}

class RemoveTagAction extends TagBaseAction {
  RemoveTagAction({
    required super.surahIndex,
    required super.ayaIndex,
    required super.tag,
  });
}

class AddTagSucceededAction extends ModifyTagResponseBaseAction {
  AddTagSucceededAction({
    required super.message,
  });
}

class AddTagFailureAction extends ModifyTagResponseBaseAction {
  AddTagFailureAction({
    required super.message,
  });
}

class RemoveTagSucceededAction extends ModifyTagResponseBaseAction {
  RemoveTagSucceededAction({
    required super.message,
  });
}

class RemoveTagFailureAction extends ModifyTagResponseBaseAction {
  RemoveTagFailureAction({
    required super.message,
  });
}

class ResetTagsAction extends AppStateAction {}

class CreateTagAction extends TagBaseAction {
  CreateTagAction({
    required super.surahIndex,
    required super.ayaIndex,
    required super.tag,
  });
}

class DeleteTagAction extends TagBaseAction {
  DeleteTagAction({
    required super.surahIndex,
    required super.ayaIndex,
    required super.tag,
  });
}

class CreateTagSucceededAction extends ModifyTagResponseBaseAction {
  CreateTagSucceededAction({
    required super.message,
  });
}

class CreateTagFailureAction extends ModifyTagResponseBaseAction {
  CreateTagFailureAction({
    required super.message,
  });
}

class DeleteTagSucceededAction extends ModifyTagResponseBaseAction {
  DeleteTagSucceededAction({
    required super.message,
  });
}

class DeleteTagFailureAction extends ModifyTagResponseBaseAction {
  DeleteTagFailureAction({
    required super.message,
  });
}

