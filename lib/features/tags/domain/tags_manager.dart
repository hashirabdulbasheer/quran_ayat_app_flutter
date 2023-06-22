import 'package:quran_ayat/features/core/data/quran_firebase_engine.dart';
import 'package:quran_ayat/misc/enums/quran_status_enum.dart';

import '../../../models/qr_response_model.dart';
import '../../../utils/utils.dart';
import 'package:intl/intl.dart' as intl;

import '../data/quran_tags_impl.dart';
import 'entities/quran_master_tag.dart';
import 'entities/quran_tag.dart';
import 'interfaces/quran_tags_interface.dart';

class QuranTagsManager implements QuranTagsDataSource {
  static final QuranTagsManager instance =
      QuranTagsManager._privateConstructor();

  QuranTagsManager._privateConstructor() {
    _tagsEngine = QuranTagsEngine(dataSource: QuranFirebaseEngine.instance);
  }

  late QuranTagsEngine _tagsEngine;

  @override
  Future<QuranResponse> create(
    String userId,
    QuranTag tag,
  ) async {
    if (await isOffline()) {
      return QuranResponse(
        isSuccessful: false,
        message: "No internet",
      );
    } else {
      /// ONLINE
      return await _tagsEngine.create(
        userId,
        tag,
      );
    }
  }

  @override
  Future<QuranResponse> createMaster(
    String userId,
    QuranMasterTag tag,
  ) async {
    if (await isOffline()) {
      return QuranResponse(
        isSuccessful: false,
        message: "No internet",
      );
    } else {
      /// ONLINE
      return await _tagsEngine.createMaster(
        userId,
        tag,
      );
    }
  }

  @override
  Future<bool> delete(
    String userId,
    QuranTag tag,
  ) async {
    /// Supporting delete for online only
    if (!await isOffline()) {
      return _tagsEngine.delete(
        userId,
        tag,
      );
    }

    /// OFFLINE
    return false;
  }

  @override
  Future<QuranTag?> fetch(
    String userId,
    int suraIndex,
    int ayaIndex,
  ) async {
    if (await isOffline()) {
      /// OFFLINE
      return null;
    } else {
      /// ONLINE
      ///
      return await _tagsEngine.fetch(
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
      return;
    }

    /// ONLINE
    return _tagsEngine.initialize();
  }

  @override
  Future<bool> update(
    String userId,
    QuranTag tag,
  ) async {
    if (!await isOffline()) {
      /// ONLINE
      return _tagsEngine.update(
        userId,
        tag,
      );
    }

    /// OFFLINE
    return false;
  }

  @override
  Future<bool> updateMaster(
    String userId,
    QuranMasterTag tag,
  ) async {
    if (!await isOffline()) {
      /// ONLINE
      return _tagsEngine.updateMaster(
        userId,
        tag,
      );
    }

    /// OFFLINE
    return false;
  }

  @override
  Future<List<QuranTag>> fetchAll(String userId) async {
    if (await isOffline()) {
      /// OFFLINE
      return [];
    }

    /// ONLINE
    return _tagsEngine.fetchAll(userId);
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
