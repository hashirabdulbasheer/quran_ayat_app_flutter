export "notes_actions.dart";
export "tag_actions.dart";

/// ACTIONS
///

class AppStateAction {
  @override
  String toString() {
    return "$runtimeType";
  }
}

enum AppStateTagModifyAction { create, addAya, removeAya, delete }

class AppStateInitializeAction extends AppStateAction {}

class AppStateResetAction extends AppStateAction {}
