import '../../../models/qr_response_model.dart';
import '../../../utils/utils.dart';
import '../../core/data/quran_data_interface.dart';
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
  Future<List<QuranTag>> fetchAll(String userId) async {
    List<QuranTag> tags = [];
    try {
      List<dynamic>? resultList =
          await dataSource.fetchAll("tags/$userId") as List<dynamic>?;
      if (resultList == null) {
        return [];
      }
      for (int surahIndex = 1; surahIndex < 115; surahIndex++) {
        for (int ayaIndex = 1; ayaIndex < 300; ayaIndex++) {
          try {
            Map<String, dynamic>? tagsList =
                resultList[surahIndex][ayaIndex] as Map<String, dynamic>?;
            if (tagsList != null && tagsList.isNotEmpty) {
              for (String tagsId in tagsList.keys) {
                QuranTag tag = QuranTag(
                  suraIndex: surahIndex,
                  ayaIndex: ayaIndex,
                  tag: tagsList[tagsId]["tag"] != null
                      ? (tagsList[tagsId]["tag"] as List)
                          .map((dynamic e) => e.toString())
                          .toList()
                      : [],
                  createdOn: tagsList[tagsId]["createdOn"] as int,
                  id: tagsId,
                  localId: "${tagsList[tagsId]["localId"] ?? ""}",
                  status: QuranUtils.statusFromString(
                    "${tagsList[tagsId]["status"] ?? ""}",
                  ),
                );
                tags.add(tag);
              }
            }
          } catch (_) {}
        }
      }

      /*
    for (int surahIndex = 1; surahIndex < 115; surahIndex++) {
      for (int ayaIndex = 1; ayaIndex < 300; ayaIndex++) {
        try {
          Map<String, dynamic>? tagsList =
          resultList["$surahIndex"]["$ayaIndex"] as Map<String, dynamic>?;
          print(tagsList.toString());
          if (tagsList != null) {
            for (String tagsId in tagsList.keys) {
              print("$surahIndex:$ayaIndex : ${tagsList[tagsId]["tag"]}");
              print("******");
              try {
                QuranTag tag = QuranTag(
                  suraIndex: surahIndex,
                  ayaIndex: ayaIndex,
                  tag: tagsList[tagsId]["tag"] != null
                      ? (tagsList[tagsId]["tag"] as List)
                      .map((dynamic e) => e.toString())
                      .toList()
                      : [],
                  createdOn: tagsList[tagsId]["createdOn"] as int,
                  id: tagsId,
                  localId: "${tagsList[tagsId]["localId"] ?? ""}",
                  status: QuranUtils.statusFromString(
                    "${tagsList[tagsId]["status"] ?? ""}",
                  ),
                );
                tags.add(tag);
              } catch (_) {}
            }
          } else {
            print("tagsList null");
          }
        } catch (_) {
          print("error");
        }
      }
    }
    // sort
    tags.sort((
      a,
      b,
    ) =>
        b.createdOn.compareTo(a.createdOn));
    */
    } catch (error) {
      print(error);
    }

    return tags;
  }

  @Deprecated("a different method to parse all results")
  Future<List<QuranTag>> fetchAllMethod2(String userId) async {
    List<QuranTag> tags = [];
    Map<String, dynamic>? resultList =
        await dataSource.fetchAll("tags/$userId") as Map<String, dynamic>?;
    if (resultList != null) {
      for (String suraIndex in resultList.keys) {
        try {
          Map<String, dynamic>? ayatList =
              resultList[suraIndex] as Map<String, dynamic>?;
          if (ayatList != null) {
            for (String ayaIndex in ayatList.keys) {
              Map<String, dynamic>? tagsList =
                  ayatList[ayaIndex] as Map<String, dynamic>?;
              if (tagsList != null) {
                for (String tagsId in tagsList.keys) {
                  // print("$suraIndex:$ayaIndex : ${tagsList[tagsId]["tag"]}");
                  // print("******");
                  try {
                    QuranTag tag = QuranTag(
                      suraIndex: int.parse(suraIndex),
                      ayaIndex: int.parse(ayaIndex),
                      tag: tagsList[tagsId]["tag"] as List<String>,
                      createdOn: tagsList[tagsId]["createdOn"] as int,
                      id: tagsId,
                      localId: "${tagsList[tagsId]["localId"] ?? ""}",
                      status: QuranUtils.statusFromString(
                        "${tagsList[tagsId]["status"] ?? ""}",
                      ),
                    );
                    tags.add(tag);
                  } catch (_) {}
                }
              }
            }
          }
        } catch (_) {}
      }
    }
    // sort
    tags.sort((
      a,
      b,
    ) =>
        b.createdOn.compareTo(a.createdOn));

    return tags;
  }
}
