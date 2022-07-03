import 'engines/firebase_auth_impl.dart';
import 'engines/quran_auth_interface.dart';

class QuranAuthFactory {
  static QuranAuthInterface get authEngine {
    return QuranFirebaseAuthEngine();
  }
}
