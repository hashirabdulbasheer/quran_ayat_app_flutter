import '../../../models/qr_response_model.dart';
import '../../../utils/logger_utils.dart';
import '../../../utils/utils.dart';
import '../../core/data/quran_data_interface.dart';
import '../domain/entities/quran_note.dart';
import '../domain/interfaces/quran_notes_interface.dart';

class QuranNotesEngine implements QuranNotesDataSource {
  final QuranDataSource dataSource;

  QuranNotesEngine({required this.dataSource});

  @override
  Future<void> initialize() async {
    return;
  }

  @override
  Future<QuranResponse> create(
    String userId,
    QuranNote note,
  ) async {
    await dataSource.create(
      "notes/$userId/${note.suraIndex + 1}/${note.ayaIndex + 1}",
      note.toMap(),
    );

    return QuranResponse(
      isSuccessful: true,
      message: "success",
    );
  }

  @override
  Future<List<QuranNote>> fetch(
    String userId,
    int suraIndex,
    int ayaIndex,
  ) async {
    List<QuranNote> notes = [];
    Map<dynamic, dynamic>? resultList = await dataSource.fetch(
      "notes/$userId/$suraIndex/$ayaIndex",
    );
    if (resultList != null) {
      for (String k in resultList.keys) {
        QuranNote note = QuranNote(
          suraIndex: suraIndex,
          ayaIndex: ayaIndex,
          note: resultList[k]["note"] as String,
          createdOn: resultList[k]["createdOn"] as int,
          id: k,
          localId: "${resultList[k]["localId"]}",
          status: QuranUtils.statusFromString("${resultList[k]["status"]}"),
        );
        notes.add(note);
      }
      // sort
      notes.sort((
        a,
        b,
      ) =>
          b.createdOn.compareTo(a.createdOn));
    }

    return notes;
  }

  @override
  Future<bool> update(
    String userId,
    QuranNote note,
  ) async {
    if (note.id != null && note.id?.isNotEmpty == true) {
      return await dataSource.update(
        "notes/$userId/${note.suraIndex + 1}/${note.ayaIndex + 1}/${note.id}",
        note.toMap(),
      );
    }

    return false;
  }

  @override
  Future<bool> delete(
    String userId,
    QuranNote note,
  ) async {
    if (note.id != null && note.id?.isNotEmpty == true) {
      return await dataSource.delete(
        "notes/$userId/${note.suraIndex + 1}/${note.ayaIndex + 1}/${note.id}",
      );
    }

    return false;
  }

  @override
  Future<List<QuranNote>> fetchAll(String userId) async {
    List<QuranNote> resultNotes = [];
    try {
      dynamic resultList = await dataSource.fetchAll("notes/$userId");
      if (resultList == null) {
        return [];
      }
      for (int surah = 1; surah <= 114; surah++) {
        dynamic notesList = resultList[surah];
        if (notesList == null) continue;
        Map<String, dynamic>? notesListMap = Map<String, dynamic>.from(
          notesList as Map,
        );
        // an aya can have multiple notes
        notesListMap.forEach((aya, dynamic notes,) {
          Map<String, dynamic> ayaNotes =
              Map<String, dynamic>.from(notes as Map);
          ayaNotes.forEach((k, dynamic note,) {
            Map<String, dynamic> noteMap =
                Map<String, dynamic>.from(note as Map);
            try {
              QuranNote quranNote = QuranNote(
                suraIndex: surah - 1,
                ayaIndex: int.parse(aya) - 1,
                note: "${noteMap["note"] ?? ""}",
                id: k,
                localId: "${noteMap["localId"] ?? ""}",
                createdOn: noteMap["createdOn"] as int,
                status: QuranUtils.statusFromString(
                  "${noteMap["status"] ?? ""}",
                ),
              );
              resultNotes.add(quranNote);
            } catch (error) {
              QuranLogger.logE(
                error,
              );
            }
          });
        });
      }
    } catch (error) {
      QuranLogger.logE(
        error,
      );
    }

    return resultNotes;
  }

  @Deprecated("a different method to parse all results")
  Future<List<QuranNote>> fetchAllMethod1(String userId) async {
    List<QuranNote> notes = [];
    dynamic resultListDyn = await dataSource.fetchAll("notes/$userId");
    final Map<String, dynamic> resultList =
        Map<String, dynamic>.from(resultListDyn as Map);

    for (int surahIndex = 1; surahIndex < 115; surahIndex++) {
      for (int ayaIndex = 1; ayaIndex < 300; ayaIndex++) {
        if (resultList.isNotEmpty) {
          try {
            Map<String, dynamic>? notesList = Map<String, dynamic>.from(
                resultList["$surahIndex"]["$ayaIndex"] as Map,);
            for (String notesId in notesList.keys) {
              // print("$surahIndex:$ayaIndex : ${notesList[notesId]["note"]}");
              // print("******");
              try {
                QuranNote note = QuranNote(
                  suraIndex: surahIndex,
                  ayaIndex: ayaIndex,
                  note: "${notesList[notesId]["note"]}",
                  createdOn: notesList[notesId]["createdOn"] as int,
                  id: notesId,
                  localId: "${notesList[notesId]["localId"] ?? ""}",
                  status: QuranUtils.statusFromString(
                    "${notesList[notesId]["status"] ?? ""}",
                  ),
                );
                notes.add(note);
              } catch (error) {
                QuranLogger.logE(
                  error,
                );
              }
            }
                    } catch (_) {
            // do not add any exception handling here as there will be many exceptions thrown
            // for invalid indexes.
          }
        }
      }
    }
    // sort
    notes.sort((
      a,
      b,
    ) =>
        b.createdOn.compareTo(a.createdOn));

    return notes;
  }

  @Deprecated("a different method to parse all results")
  Future<List<QuranNote>> fetchAllMethod2(String userId) async {
    List<QuranNote> notes = [];
    Map<String, dynamic>? resultList =
        await dataSource.fetchAll("notes/$userId") as Map<String, dynamic>?;
    if (resultList != null) {
      for (String suraIndex in resultList.keys) {
        try {
          Map<String, dynamic>? ayatList =
              resultList[suraIndex] as Map<String, dynamic>?;
          if (ayatList != null) {
            for (String ayaIndex in ayatList.keys) {
              Map<String, dynamic>? notesList =
                  ayatList[ayaIndex] as Map<String, dynamic>?;
              if (notesList != null) {
                for (String notesId in notesList.keys) {
                  // print("$suraIndex:$ayaIndex : ${notesList[notesId]["note"]}");
                  // print("******");
                  try {
                    QuranNote note = QuranNote(
                      suraIndex: int.parse(suraIndex),
                      ayaIndex: int.parse(ayaIndex),
                      note: "${notesList[notesId]["note"]}",
                      createdOn: notesList[notesId]["createdOn"] as int,
                      id: notesId,
                      localId: "${notesList[notesId]["localId"] ?? ""}",
                      status: QuranUtils.statusFromString(
                        "${notesList[notesId]["status"] ?? ""}",
                      ),
                    );
                    notes.add(note);
                  } catch (_) {}
                }
              }
            }
          }
        } catch (_) {}
      }
    }
    // sort
    notes.sort((
      a,
      b,
    ) =>
        b.createdOn.compareTo(a.createdOn));

    return notes;
  }
}
