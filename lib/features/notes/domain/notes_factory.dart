import '../data/firebase_notes_impl.dart';
import 'interfaces/quran_notes_interface.dart';

class QuranNotesFactory {
  static QuranNotesInterface get engine {
    return QuranFirebaseNotesEngine.instance;
  }
}
