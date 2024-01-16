import '../../../models/qr_response_model.dart';
import '../../../utils/utils.dart';
import '../../core/data/quran_firebase_engine.dart';
import '../data/hive_notes_impl.dart';
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
    if (await isOffline()) {
      /// OFFLINE
      return await _offlineEngine.create(
        userId,
        note,
      );
    } else {
      /// ONLINE
      return await _notesEngine.create(
        userId,
        note,
      );
    }
  }

  @override
  Future<bool> delete(
    String userId,
    QuranNote note,
  ) async {
    /// Supporting delete for online only
    if (!await isOffline()) {
      return _notesEngine.delete(
        userId,
        note,
      );
    }

    /// OFFLINE
    return _offlineEngine.delete(
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
    if (await isOffline()) {
      /// OFFLINE
      return await _offlineEngine.fetch(
        userId,
        suraIndex,
        ayaIndex,
      );
    } else {
      /// ONLINE
      return await _notesEngine.fetch(
        userId,
        suraIndex,
        ayaIndex,
      );
    }
  }

  @override
  Future<void> initialize() async {
    if (await isOffline()) {
      /// OFFLINE
      await _offlineEngine.initialize();
    }

    /// ONLINE
    return _notesEngine.initialize();
  }

  @override
  Future<bool> update(
    String userId,
    QuranNote note,
  ) async {
    if (!await isOffline()) {
      /// ONLINE
      return _notesEngine.update(
        userId,
        note,
      );
    }

    /// OFFLINE
    return _offlineEngine.update(
      userId,
      note,
    );
  }

  Future<void> uploadLocalNotesIfAny(String userId) async {
    if (!await isOffline()) {
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
  }

  @override
  Future<List<QuranNote>> fetchAll(String userId) async {
    if (await isOffline()) {
      /// OFFLINE
      return await _offlineEngine.fetchAll(userId);
    }

    /// ONLINE
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

  Future<bool> isOffline() async {
    return QuranUtils.isOffline();
  }

  String formattedDate(int timeMs) {
    return QuranUtils.formattedDate(timeMs);
  }
}
