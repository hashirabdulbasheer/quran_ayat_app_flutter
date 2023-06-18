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

  QuranNotesManager._privateConstructor() {
    _notesEngine = QuranNotesEngine(dataSource: QuranFirebaseEngine.instance);
  }

  late QuranNotesEngine _notesEngine;

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
    DateTime now = DateTime.now();
    DateTime justNow = DateTime.now().subtract(const Duration(minutes: 1));
    var millis = DateTime.fromMillisecondsSinceEpoch(timeMs);
    if (!millis.difference(justNow).isNegative) {
      return 'Just now';
    }
    if (millis.day == now.day &&
        millis.month == now.month &&
        millis.year == now.year) {
      return intl.DateFormat('jm').format(now);
    }
    DateTime yesterday = now.subtract(const Duration(days: 1));
    if (millis.day == yesterday.day &&
        millis.month == yesterday.month &&
        millis.year == yesterday.year) {
      return 'Yesterday, ${intl.DateFormat('jm').format(now)}';
    }
    if (now.difference(millis).inDays < 4) {
      String weekday = intl.DateFormat('EEEE').format(millis);

      return '$weekday, ${intl.DateFormat('jm').format(now)}';
    }
    var d24 = intl.DateFormat('dd/MM/yyyy HH:mm').format(millis);

    return d24;
  }
}
