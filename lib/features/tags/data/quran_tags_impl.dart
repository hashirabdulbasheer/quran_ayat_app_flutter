import 'package:quran_ayat/features/tags/domain/entities/quran_master_tag_aya.dart';

import '../../../models/qr_response_model.dart';
import '../../../utils/utils.dart';
import '../../core/data/quran_data_interface.dart';
import '../domain/entities/quran_master_tag.dart';
import '../domain/entities/quran_tag.dart';
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
    QuranTag tag,
  ) async {
    await dataSource.create(
      "tags/$userId/${tag.suraIndex}/${tag.ayaIndex}",
      tag.toMap(),
    );

    return QuranResponse(
      isSuccessful: true,
      message: "success",
    );
  }

  @override
  Future<QuranResponse> createMaster(
    String userId,
    QuranMasterTag masterTag,
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
  Future<QuranTag?> fetch(
    String userId,
    int suraIndex,
    int ayaIndex,
  ) async {
    Map<String, dynamic>? resultList = await dataSource.fetch(
      "tags/$userId/$suraIndex/$ayaIndex",
    );
    if (resultList != null && resultList.isNotEmpty) {
      String firstItemId = resultList.keys.first;
      dynamic firstItem = resultList[firstItemId];

      return QuranTag(
        suraIndex: suraIndex,
        ayaIndex: ayaIndex,
        tag: firstItem["tag"] != null
            ? (firstItem["tag"] as List)
                .map((dynamic e) => e.toString())
                .toList()
            : [],
        createdOn: firstItem["createdOn"] as int,
        id: firstItemId,
        localId: "${firstItem["localId"]}",
        status: QuranUtils.statusFromString("${firstItem["status"]}"),
      );
    }

    return null;
  }

  @override
  Future<bool> update(
    String userId,
    QuranTag tag,
  ) async {
    if (tag.id != null && tag.id?.isEmpty == false) {
      return await dataSource.update(
        "tags/$userId/${tag.suraIndex}/${tag.ayaIndex}/${tag.id}",
        tag.toMap(),
      );
    }

    return false;
  }

  @override
  Future<bool> updateMaster(
    String userId,
    QuranMasterTag masterTag,
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
  Future<bool> delete(
    String userId,
    QuranTag tag,
  ) async {
    if (tag.id != null && tag.id?.isEmpty == false) {
      return await dataSource
          .delete("tags/$userId/${tag.suraIndex}/${tag.ayaIndex}/${tag.id}");
    }

    return false;
  }

  @override
  Future<List<QuranMasterTag>> fetchAll(String userId) async {
    List<QuranMasterTag> tags = [];
    try {
      Map<String, dynamic>? resultList = await dataSource
          .fetchAll("tags-master/$userId") as Map<String, dynamic>?;
      if (resultList == null) {
        return [];
      }
      for (String tagKey in resultList.keys) {
        Map<String, dynamic> tag = resultList[tagKey] as Map<String, dynamic>;
        QuranMasterTag masterTag = QuranMasterTag(
          id: tagKey,
          name: tag["name"] as String,
          ayas: tag["ayas"] != null
              ? (tag["ayas"] as List<dynamic>)
                  .map((dynamic e) => QuranMasterTagAya(
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
      print(error);
    }

    return tags;
  }
}
