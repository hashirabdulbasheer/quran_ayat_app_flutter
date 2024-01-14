import 'package:quran_ayat/features/auth/domain/auth_factory.dart';
import 'package:quran_ayat/models/qr_user_model.dart';
import 'package:redux/redux.dart';

import '../../../../../challenge/domain/redux/actions/actions.dart';
import '../../../../../newAyat/domain/redux/actions/actions.dart';
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

    // setting user role
    QuranUser? user = QuranAuthFactory.engine.getUser();
    if (user != null) {
      bool isAdmin = await QuranAuthFactory.engine.isAdmin(user.uid);
      store.dispatch(AppStateUserRoleAction(isAdmin: isAdmin));
    }
  }
  next(action);
}
