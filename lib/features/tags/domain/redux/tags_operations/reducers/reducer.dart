import 'package:redux/redux.dart';

import '../../../../../core/domain/app_state/app_state.dart';
import '../../../entities/quran_tag.dart';
import '../../../entities/quran_tag_aya.dart';
import '../actions/actions.dart';
import '../tag_operations_state.dart';

/// REDUCER
///
Reducer<TagOperationsState> tagOperationsReducer =
    combineReducers<TagOperationsState>([
  TypedReducer<TagOperationsState, AppStateFetchTagsSucceededAction>(
    _tagAyaFetchTagsReducer,
  ),
  TypedReducer<TagOperationsState, AddTagOperationSucceededAction>(
    _tagAyaAddTagsSuccessReducer,
  ),
  TypedReducer<TagOperationsState, AddTagOperationFailureAction>(
    _tagAyaAddTagsFailureReducer,
  ),
  TypedReducer<TagOperationsState, ResetTagsAction>(
    _resetTagsReducer,
  ),
]);

TagOperationsState _tagAyaFetchTagsReducer(
  TagOperationsState state,
  AppStateFetchTagsSucceededAction action,
) {
  Map<String, List<String>> stateTags = {};
  for (QuranTag tag in action.fetchedTags) {
    for (QuranTagAya aya in tag.ayas) {
      String key = "${aya.suraIndex}_${aya.ayaIndex}";
      if (stateTags[key] == null) {
        stateTags[key] = [];
      }
      stateTags[key]?.add(tag.name);
    }
  }

  return state.copyWith(
    originalTags: action.fetchedTags,
    tags: stateTags,
  );
}

TagOperationsState _tagAyaAddTagsSuccessReducer(
  TagOperationsState state,
  AddTagOperationSucceededAction action,
) {
  return state.copyWith(
    lastActionStatus: AppStateActionStatus(
      action: action.runtimeType.toString(),
      message: action.message,
    ),
  );
}

TagOperationsState _tagAyaAddTagsFailureReducer(
  TagOperationsState state,
  AddTagOperationFailureAction action,
) {
  return state.copyWith(
    lastActionStatus: AppStateActionStatus(
      action: action.runtimeType.toString(),
      message: action.message,
    ),
  );
}

TagOperationsState _resetTagsReducer(
  TagOperationsState state,
  ResetTagsAction action,
) {
  return state.copyWith(
    lastActionStatus: const AppStateActionStatus(
      action: "",
      message: "",
    ),
  );
}
