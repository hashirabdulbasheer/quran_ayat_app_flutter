import 'package:equatable/equatable.dart';

export "notes_actions.dart";
export "tag_actions.dart";

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
