import 'package:redux/redux.dart';

import '../../../../../core/domain/app_state/app_state.dart';
import '../../../entities/quran_tag.dart';
import '../../../entities/quran_tag_aya.dart';
import '../actions/actions.dart';
import '../tag_operations_state.dart';

/// REDUCER
///
Reducer<TagOperationsState> tagOperationsReducer = combineReducers<TagOperationsState>([
  TypedReducer<TagOperationsState, AppStateFetchTagsSucceededAction>(tagAyaFetchTagsReducer),
  TypedReducer<TagOperationsState, AddTagOperationSucceededAction>(tagAyaAddTagsSuccessReducer),
  TypedReducer<TagOperationsState, AddTagOperationFailureAction>(tagAyaAddTagsFailureReducer),
]);

TagOperationsState tagAyaFetchTagsReducer(
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

TagOperationsState tagAyaAddTagsSuccessReducer(
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

TagOperationsState tagAyaAddTagsFailureReducer(
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
