import '../../../models/qr_response_model.dart';
import '../../../utils/utils.dart';
import '../../core/data/quran_firebase_engine.dart';
import '../data/dummy_offline_impl.dart';
import '../data/quran_notes_impl.dart';
import 'entities/quran_note.dart';
import 'interfaces/quran_notes_interface.dart';

class QuranNotesManager implements QuranNotesDataSource {
  static final QuranNotesManager instance =
      QuranNotesManager._privateConstructor();

  QuranNotesManager._privateConstructor();

  final QuranNotesEngine _notesEngine =
      QuranNotesEngine(dataSource: QuranFirebaseEngine.instance);

  /// TODO: Hive disabled temporarily - using a dummy data source for offline mode
  ///  To enable hive enable here
  // final QuranNotesDataSource _offlineEngine = QuranHiveNotesEngine.instance;
  final QuranNotesDataSource _offlineEngine = DummyOfflineEngine();

  QuranNotesDataSource get offlineEngine => _offlineEngine;

  @override
  Future<QuranResponse> create(
    String userId,
    QuranNote note,
  ) async {
    return await _notesEngine.create(
      userId,
      note,
    );
  }

  @override
  Future<bool> delete(
    String userId,
    QuranNote note,
  ) async {
    return _notesEngine.delete(
      userId,
      note,
    );
  }

  @override
  Future<List<QuranNote>> fetch(
    String userId,
    int suraIndex,
    int ayaIndex,
  ) async {
    return await _notesEngine.fetch(
      userId,
      suraIndex,
      ayaIndex,
    );
  }

  @override
  Future<void> initialize() async {
    return _notesEngine.initialize();
  }

  @override
  Future<bool> update(
    String userId,
    QuranNote note,
  ) async {
    return _notesEngine.update(
      userId,
      note,
    );
  }

  Future<void> uploadLocalNotesIfAny(String userId) async {
    // ONLINE -> Upload all local notes if any
    List<QuranNote> localNotes = await fetchAllLocal(userId);
    for (QuranNote note in localNotes) {
      // create online copy
      create(
        userId,
        note,
      );
      // delete local copy
      deleteLocal(
        userId,
        note,
      );
    }
  }

  @override
  Future<List<QuranNote>> fetchAll(String userId) async {
    return _notesEngine.fetchAll(userId);
  }

  Future<List<QuranNote>> fetchAllLocal(String userId) {
    return _offlineEngine.fetchAll(userId);
  }

  Future<bool> deleteLocal(
    String userId,
    QuranNote note,
  ) {
    return _offlineEngine.delete(
      userId,
      note,
    );
  }

  String formattedDate(int timeMs) {
    return QuranUtils.formattedDate(timeMs);
  }
}
