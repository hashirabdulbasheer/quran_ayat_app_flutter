import '../../../models/qr_response_model.dart';
import '../domain/entities/quran_note.dart';
import '../domain/interfaces/quran_notes_interface.dart';

class DummyOfflineEngine implements QuranNotesDataSource {
  @override
  Future<QuranResponse> create(
    String userId,
    QuranNote note,
  ) {
    return Future.value(QuranResponse(
      isSuccessful: false,
      message: "disabled",
    ));
  }

  @override
  Future<bool> delete(
    String userId,
    QuranNote note,
  ) {
    return Future.value(false);
  }

  @override
  Future<List<QuranNote>> fetch(
    String userId,
    int suraIndex,
    int ayaIndex,
  ) {
    return Future.value(<QuranNote>[]);
  }

  @override
  Future<List<QuranNote>> fetchAll(String userId) {
    return Future.value(<QuranNote>[]);
  }

  @override
  Future<void> initialize() {
    return Future.value();
  }

  @override
  Future<bool> update(
    String userId,
    QuranNote note,
  ) {
    return Future.value(false);
  }
}
