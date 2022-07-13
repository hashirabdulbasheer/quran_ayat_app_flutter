import 'package:hive_flutter/hive_flutter.dart';
import '../../../misc/enums/quran_status_enum.dart';
import '../../../models/qr_response_model.dart';
import '../../../utils/utils.dart';
import '../domain/entities/quran_note.dart';
import '../domain/interfaces/quran_notes_interface.dart';
import 'models/quran_note_dto.dart';

class QuranHiveNotesEngine implements QuranNotesInterface {
  QuranHiveNotesEngine._privateConstructor();

  static final QuranHiveNotesEngine instance =
      QuranHiveNotesEngine._privateConstructor();

  @override
  Future<QuranResponse> create(String userId, QuranNote note) async {
    QuranNoteDto noteDto = QuranNoteDto(
        suraIndex: note.suraIndex,
        ayaIndex: note.ayaIndex,
        id: note.id,
        createdOn: note.createdOn,
        note: note.note,
        status: QuranStatusEnum.created.rawString(),
        localId: QuranUtils.uniqueId());
    String key = "$userId/${note.suraIndex}/${note.ayaIndex}";
    var box = await Hive.openBox<List<QuranNoteDto>>('notesBox');
    List<QuranNoteDto> items = box.get(key) ?? [];
    items.add(noteDto);
    box.put(key, items);
    return QuranResponse(isSuccessful: true, message: "success");
  }

  @override
  Future<bool> delete(String userId, QuranNote note) async {
    String key = "$userId/${note.suraIndex}/${note.ayaIndex}";
    var box = await Hive.openBox<List<QuranNoteDto>>('notesBox');
    List<QuranNoteDto> items = box.get(key) ?? [];
    items.removeWhere((element) =>
        (element.localId == note.localId) ||
        (element.id != null && element.id == note.id));
    box.put(key, items);
    return true;
  }

  @override
  Future<List<QuranNote>> fetch(
      String userId, int suraIndex, int ayaIndex) async {
    String key = "$userId/$suraIndex/$ayaIndex";
    var box = await Hive.openBox<List<QuranNoteDto>>('notesBox');
    List<QuranNoteDto> items = box.get(key) ?? [];
    return items
        .map((e) => QuranNote(
            suraIndex: e.suraIndex,
            ayaIndex: e.ayaIndex,
            id: e.id,
            createdOn: e.createdOn,
            note: e.note,
            status: QuranUtils.statusFromString(e.status),
            localId: e.localId))
        .toList();
  }

  @override
  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(QuranNoteDtoAdapter());
  }

  @override
  Future<bool> update(String userId, QuranNote note) async {
    String key = "$userId/${note.suraIndex}/${note.ayaIndex}";
    var box = await Hive.openBox<List<QuranNoteDto>>('notesBox');
    List<QuranNoteDto> items = box.get(key) ?? [];
    int itemIndex = items.indexWhere((element) =>
        (element.localId == note.localId) ||
        (element.id != null && element.id == note.id));
    if (itemIndex >= 0) {
      QuranNoteDto updatedDto = QuranNoteDto(
          suraIndex: note.suraIndex,
          ayaIndex: note.ayaIndex,
          id: note.id,
          createdOn: note.createdOn,
          note: note.note,
          status: QuranStatusEnum.updated.rawString(),
          localId: note.localId);
      items[itemIndex] = updatedDto;
      box.put(key, items);
      return true;
    }
    return false;
  }

}
