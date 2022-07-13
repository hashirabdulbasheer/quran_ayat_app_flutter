import 'package:quran_ayat/features/notes/data/hive_notes_impl.dart';
import 'interfaces/quran_notes_interface.dart';

class QuranNotesFactory {
  static QuranNotesInterface get engine {
    return QuranHiveNotesEngine.instance;
  }
}
