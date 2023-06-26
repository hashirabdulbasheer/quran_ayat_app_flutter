import '../../../models/qr_response_model.dart';
import '../../core/data/quran_data_interface.dart';
import '../domain/entities/quran_master_tag.dart';
import '../domain/entities/quran_master_tag_aya.dart';
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
  Future<bool> update(
    String userId,
    QuranMasterTag masterTag,
  ) async {
    print("${masterTag.id}");
    if (masterTag.id != null && masterTag.id?.isEmpty == false) {
      return await dataSource.update(
        "tags-master/$userId/${masterTag.id}",
        masterTag.toMap(),
      );
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
