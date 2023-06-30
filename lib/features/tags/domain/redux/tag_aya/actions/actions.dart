import '../../../../../core/domain/app_state/redux/actions/actions.dart';

class AddTagOperationAction extends AppStateTagBaseAction {
  AddTagOperationAction({
    required super.surahIndex,
    required super.ayaIndex,
    required super.tag,
  });
}

class RemoveTagOperationAction extends AppStateTagBaseAction {
  RemoveTagOperationAction({
    required super.surahIndex,
    required super.ayaIndex,
    required super.tag,
  });
}

class AddTagOperationSucceededAction
    extends AppStateModifyTagResponseBaseAction {
  AddTagOperationSucceededAction({
    required super.message,
  });
}

class AddTagOperationFailureAction
    extends AppStateModifyTagResponseBaseAction {
  AddTagOperationFailureAction({
    required super.message,
  });
}

class RemoveTagOperationSucceededAction
    extends AppStateModifyTagResponseBaseAction {
  RemoveTagOperationSucceededAction({
    required super.message,
  });
}

class RemoveTagOperationFailureAction
    extends AppStateModifyTagResponseBaseAction {
  RemoveTagOperationFailureAction({
    required super.message,
  });
}
