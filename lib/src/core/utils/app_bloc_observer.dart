import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);

    log('onCreate() - bloc: $bloc');
    log('-----------------------------------------------------------');
  }

  // This is for Blocs.
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);

    log('onTransition() - bloc: $bloc');
    // log('onTransition() - currentState: ${transition.currentState}');
    log('onTransition() - event: ${transition.event}');
    // log('onTransition() - nextState: ${transition.nextState}');
    log('-----------------------------------------------------------');
  }

  // This is for Cubits.
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);

    log('onChange() - bloc: $bloc');
    // log('onChange() - currentState: ${change.currentState}');
    // log('onChange() - nextState: ${change.nextState}');
    log('-----------------------------------------------------------');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);

    log('onError() - bloc: $bloc');
    log('onError() - error: $error');
    log('onError() - stackTrace: $stackTrace');
    log('-----------------------------------------------------------');
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);

    log('onClose() - bloc: $bloc');
    log('-----------------------------------------------------------');
  }
}
