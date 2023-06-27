import '../../../misc/enums/quran_status_enum.dart';
import '../../../models/qr_response_model.dart';
import '../../../utils/utils.dart';
import 'package:intl/intl.dart' as intl;
import '../../core/data/quran_firebase_engine.dart';
import '../data/quran_tags_impl.dart';
import 'entities/quran_tag.dart';

class QuranTagsManager {
  static final QuranTagsManager instance =
      QuranTagsManager._privateConstructor();

  QuranTagsManager._privateConstructor();

  final QuranTagsEngine _tagsEngine =
      QuranTagsEngine(dataSource: QuranFirebaseEngine.instance);

  Future<QuranResponse> create(
    String userId,
    String tag,
  ) async {
    if (await isOffline()) {
      return QuranResponse(
        isSuccessful: false,
        message: "No internet",
      );
    } else {
      /// ONLINE
      QuranTag masterTag = QuranTag(
        id: "${DateTime.now().millisecondsSinceEpoch}",
        name: tag,
        ayas: [],
        createdOn: DateTime.now().millisecondsSinceEpoch,
        status: QuranStatusEnum.created.rawString(),
      );

      return await _tagsEngine.create(
        userId,
        masterTag,
      );
    }
  }

  Future<void> initialize() async {
    if (await isOffline()) {
      /// OFFLINE
      return;
    }

    /// ONLINE
    return _tagsEngine.initialize();
  }

  Future<bool> update(
    String userId,
    QuranTag? tag,
  ) async {
    if (!await isOffline()) {
      /// ONLINE
      if (tag != null) {
        return _tagsEngine.update(
          userId,
          tag,
        );
      }
    }

    /// OFFLINE
    return false;
  }

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
