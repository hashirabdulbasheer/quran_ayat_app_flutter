import '../../../models/qr_response_model.dart';
import '../../../utils/logger_utils.dart';
import '../../core/data/quran_data_interface.dart';
import '../domain/entities/quran_tag.dart';
import '../domain/entities/quran_tag_aya.dart';
import '../domain/interfaces/quran_tags_interface.dart';

class QuranTagsEngine implements QuranTagsDataSource {
  final QuranDataSource dataSource;

  QuranTagsEngine({required this.dataSource});

  @override
  Future<void> initialize() async {
    return;
  }

  @override
  Future<QuranResponse> create(
    String userId,
    QuranTag masterTag,
  ) async {
    await dataSource.create(
      "tags-master/$userId",
      masterTag.toMap(),
    );

    return QuranResponse(
      isSuccessful: true,
      message: "success",
    );
  }

  @override
  Future<bool> update(
    String userId,
    QuranTag masterTag,
  ) async {
    if (masterTag.id != null && masterTag.id?.isEmpty == false) {
      return await dataSource.update(
        "tags-master/$userId/${masterTag.id}",
        masterTag.toMap(),
      );
    }

    return false;
  }

  @override
  Future<List<QuranTag>> fetchAll(String userId) async {
    List<QuranTag> tags = [];
    try {
      dynamic resultList = await dataSource.fetchAll("tags-master/$userId");
      if (resultList == null) {
        return [];
      }
      for (String tagKey in resultList.keys) {
        Map<String, dynamic>? tag =
            Map<String, dynamic>.from(resultList[tagKey] as Map);
        QuranTag masterTag = QuranTag(
          id: tagKey,
          name: tag["name"] as String,
          ayas: tag["ayas"] != null
              ? (tag["ayas"] as List<dynamic>)
                  .map((dynamic e) => QuranTagAya(
                        suraIndex: e["sura"] as int,
                        ayaIndex: e["aya"] as int,
                      ))
                  .toList()
              : [],
          createdOn: tag["createdOn"] as int,
          status: tag["status"] as String,
        );
        tags.add(masterTag);
      }
    } catch (error) {
      QuranLogger.logE(
        error,
      );
    }

    return tags;
  }
}
