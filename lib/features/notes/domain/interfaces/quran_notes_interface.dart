import '../../../../models/qr_response_model.dart';
import '../entities/quran_note.dart';

abstract class QuranNotesInterface {
  Future<QuranResponse> create(String userId, QuranNote note);

  Future<List<QuranNote>> fetch(
      String userId, int suraIndex, int ayaIndex);

  Future<bool> delete(String userId, QuranNote note);

  Future<bool> update(String userId, QuranNote note);
}