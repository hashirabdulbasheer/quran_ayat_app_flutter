import 'package:quran_ayat/utils/logger_utils.dart';
import 'package:redux/redux.dart';
import '../../../../../notes/domain/redux/actions/actions.dart';
import '../../../../../tags/domain/redux/actions/actions.dart';
import '../../app_state.dart';

/// MIDDLEWARE
///

void appStateMiddleware(
  Store<AppState> store,
  dynamic action,
  NextDispatcher next,
) async {
  if (action is AppStateInitializeAction) {
    // Initialization actions
    store.dispatch(InitializeTagsAction());
    store.dispatch(InitializeNotesAction());
  }
  QuranLogger.addSentryBreadcrumbs(action.toString());
  next(action);
}
