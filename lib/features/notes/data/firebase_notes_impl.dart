import 'package:firebase_database/firebase_database.dart';
import '../../../models/qr_response_model.dart';
import '../../../utils/utils.dart';
import '../domain/entities/quran_note.dart';
import '../domain/interfaces/quran_notes_interface.dart';

class QuranFirebaseNotesEngine implements QuranNotesInterface {
  QuranFirebaseNotesEngine._privateConstructor();

  static final QuranFirebaseNotesEngine instance =
      QuranFirebaseNotesEngine._privateConstructor();

  @override
  Future<void> initialize() async {
    return;
  }

  @override
  Future<QuranResponse> create(String userId, QuranNote note) async {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref("notes/$userId/${note.suraIndex}/${note.ayaIndex}");
    DatabaseReference newPostRef = ref.push();
    await newPostRef.set(note.toMap());
    return QuranResponse(isSuccessful: true, message: "Success");
  }

  @override
  Future<List<QuranNote>> fetch(
      String userId, int suraIndex, int ayaIndex) async {
    List<QuranNote> notes = [];
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("notes/$userId/$suraIndex/$ayaIndex");
    final snapshot = await ref.get();
    Map<String, dynamic>? resultList = snapshot.value as Map<String, dynamic>?;
    if (resultList != null) {
      for (String k in resultList.keys) {
        QuranNote note = QuranNote(
            suraIndex: suraIndex,
            ayaIndex: ayaIndex,
            note: resultList[k]["note"],
            createdOn: resultList[k]["createdOn"],
            id: k,
            localId: resultList[k]["localId"],
            status: QuranUtils.statusFromString(resultList[k]["status"]));
        notes.add(note);
      }
      // sort
      notes.sort((a, b) => b.createdOn.compareTo(a.createdOn));
    }
    return notes;
  }

  @override
  Future<bool> update(String userId, QuranNote note) async {
    if (note.id != null && note.id?.isNotEmpty == true) {
      DatabaseReference ref = FirebaseDatabase.instance
          .ref("notes/$userId/${note.suraIndex}/${note.ayaIndex}/${note.id}");
      await ref.set(note.toMap());
      return true;
    }
    return false;
  }

  @override
  Future<bool> delete(String userId, QuranNote note) async {
    if (note.id != null && note.id?.isNotEmpty == true) {
      DatabaseReference ref = FirebaseDatabase.instance
          .ref("notes/$userId/${note.suraIndex}/${note.ayaIndex}/${note.id}");
      await ref.remove();
      return true;
    }
    return false;
  }

  @override
  Future<List<QuranNote>> fetchAll(String userId) async {
    List<QuranNote> notes = [];
    DatabaseReference ref = FirebaseDatabase.instance.ref("notes/$userId");
    final snapshot = await ref.get();
    Map<String, dynamic>? resultList = snapshot.value as Map<String, dynamic>?;
    for (int surahIndex = 1; surahIndex < 115; surahIndex++) {
      for (int ayaIndex = 1; ayaIndex < 300; ayaIndex++) {
        if (resultList != null) {
          try {
            Map<String, dynamic>? notesList =
                resultList["$surahIndex"]["$ayaIndex"] as Map<String, dynamic>?;
            if (notesList != null) {
              for (String notesId in notesList.keys) {
                // print("$surahIndex:$ayaIndex : ${notesList[notesId]["note"]}");
                // print("******");
                try {
                  QuranNote note = QuranNote(
                      suraIndex: surahIndex,
                      ayaIndex: ayaIndex,
                      note: "${notesList[notesId]["note"]}",
                      createdOn: notesList[notesId]["createdOn"],
                      id: notesId,
                      localId: "${notesList[notesId]["localId"] ?? ""}",
                      status: QuranUtils.statusFromString(
                          "${notesList[notesId]["status"] ?? ""}"));
                  notes.add(note);
                } catch (_) {}
              }
            }
          } catch (_) {}
        }
      }
    }
    // sort
    notes.sort((a, b) => b.createdOn.compareTo(a.createdOn));
    return notes;
  }

  @Deprecated("a different method to parse all results")
  Future<List<QuranNote>> fetchAllMethod2(String userId) async {
    List<QuranNote> notes = [];
    DatabaseReference ref = FirebaseDatabase.instance.ref("notes/$userId");
    final snapshot = await ref.get();
    Map<String, dynamic>? resultList = snapshot.value as Map<String, dynamic>?;
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
                        createdOn: notesList[notesId]["createdOn"],
                        id: notesId,
                        localId: "${notesList[notesId]["localId"] ?? ""}",
                        status: QuranUtils.statusFromString(
                            "${notesList[notesId]["status"] ?? ""}"));
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
    notes.sort((a, b) => b.createdOn.compareTo(a.createdOn));
    return notes;
  }
}
