import '../data/firebase_auth_impl.dart';
import 'interfaces/quran_auth_interface.dart';

class QuranAuthFactory {
  static QuranAuthInterface get engine {
    return QuranFirebaseAuthEngine();
  }
}
