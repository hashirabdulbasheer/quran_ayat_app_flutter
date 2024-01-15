import 'package:quran_ayat/features/core/data/quran_firebase_engine.dart';

import '../../../models/qr_response_model.dart';
import '../../../utils/utils.dart';
import '../data/hive_notes_impl.dart';
import '../data/quran_notes_impl.dart';
import 'entities/quran_note.dart';
import 'interfaces/quran_notes_interface.dart';
import 'package:intl/intl.dart' as intl;

class QuranNotesManager implements QuranNotesDataSource {
  static final QuranNotesManager instance =
      QuranNotesManager._privateConstructor();

  QuranNotesManager._privateConstructor();

  final QuranNotesEngine _notesEngine =
      QuranNotesEngine(dataSource: QuranFirebaseEngine.instance);

  @override
  Future<QuranResponse> create(
    String userId,
    QuranNote note,
  ) async {
    if (await isOffline()) {
      /// OFFLINE
      return await QuranHiveNotesEngine.instance.create(
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
    return QuranHiveNotesEngine.instance.delete(
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
      return await QuranHiveNotesEngine.instance.fetch(
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
      await QuranHiveNotesEngine.instance.initialize();
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
    return QuranHiveNotesEngine.instance.update(
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
      return await QuranHiveNotesEngine.instance.fetchAll(userId);
    }

    /// ONLINE
    return _notesEngine.fetchAll(userId);
  }

  Future<List<QuranNote>> fetchAllLocal(String userId) {
    return QuranHiveNotesEngine.instance.fetchAll(userId);
  }

  Future<bool> deleteLocal(
    String userId,
    QuranNote note,
  ) {
    return QuranHiveNotesEngine.instance.delete(
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
