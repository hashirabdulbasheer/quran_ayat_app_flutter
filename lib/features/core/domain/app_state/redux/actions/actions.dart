import 'package:equatable/equatable.dart';

import '../../../../../../misc/enums/quran_app_mode_enum.dart';

/// ACTIONS
///

class AppStateAction extends Equatable {
  @override
  String toString() {
    return "$runtimeType";
  }

  @override
  List<Object> get props => [];
}

class AppStateActionStatus extends Equatable {
  final String action;
  final String message;

  const AppStateActionStatus({
    required this.action,
    required this.message,
  });

  @override
  List<Object> get props => [
        action,
        message,
      ];

  @override
  String toString() {
    return '{action: $action, message: $message}';
  }
}

class AppStateInitializeAction extends AppStateAction {}

class AppStateResetAction extends AppStateAction {}

class AppStateLoadingAction extends AppStateAction {
  final bool isLoading;

  AppStateLoadingAction({
    required this.isLoading,
  });

  @override
  String toString() {
    return '{action: ${super.toString()}, isLoading: $isLoading}';
  }
}

class AppStateResetStatusAction extends AppStateAction {}

class AppStateSelectAppModeAction extends AppStateAction {
  final QuranAppMode appMode;

  AppStateSelectAppModeAction({
    required this.appMode,
  });

  @override
  String toString() {
    return '{action: ${super.toString()}, appMode: ${appMode.rawString()}';
  }
}
