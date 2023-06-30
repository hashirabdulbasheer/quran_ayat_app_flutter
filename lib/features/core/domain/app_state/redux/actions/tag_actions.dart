import '../../../../../tags/domain/entities/quran_tag.dart';
import 'actions.dart';


/// Operations
///
class AppStateCreateTagAction extends AppStateTagBaseAction {
  AppStateCreateTagAction({
    required super.surahIndex,
    required super.ayaIndex,
    required super.tag,
  });
}



class AppStateDeleteTagAction extends AppStateTagBaseAction {
  AppStateDeleteTagAction({
    required super.surahIndex,
    required super.ayaIndex,
    required super.tag,
  });
}



/// Operations
///



class AppStateCreateTagSucceededAction
    extends AppStateModifyTagResponseBaseAction {
  AppStateCreateTagSucceededAction({
    required super.message,
  });
}

class AppStateCreateTagFailureAction
    extends AppStateModifyTagResponseBaseAction {
  AppStateCreateTagFailureAction({
    required super.message,
  });
}


class AppStateDeleteTagSucceededAction
    extends AppStateModifyTagResponseBaseAction {
  AppStateDeleteTagSucceededAction({
    required super.message,
  });
}

class AppStateDeleteTagFailureAction
    extends AppStateModifyTagResponseBaseAction {
  AppStateDeleteTagFailureAction({
    required super.message,
  });
}
