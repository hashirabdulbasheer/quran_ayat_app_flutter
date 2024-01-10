import 'package:quran_ayat/features/challenge/domain/redux/actions/actions.dart';
import 'package:quran_ayat/features/newAyat/domain/redux/actions/actions.dart';
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
    store.dispatch(InitializeReaderScreenAction());
    store.dispatch(InitializeChallengeScreenAction(questions: const []));
  }
  next(action);
}
