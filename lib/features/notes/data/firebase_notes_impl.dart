import 'package:firebase_database/firebase_database.dart';
import '../../../models/qr_response_model.dart';
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
    await newPostRef.set({"note": note.note, "createdOn": note.createdOn});
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
            status: resultList[k]["status"]);
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
      await ref.set({"note": note.note, "createdOn": note.createdOn});
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
}
