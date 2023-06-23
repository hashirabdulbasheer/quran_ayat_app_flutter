import 'package:hive_flutter/hive_flutter.dart';
import '../../../misc/enums/quran_status_enum.dart';
import '../../../models/qr_response_model.dart';
import '../../../utils/utils.dart';
import '../domain/entities/quran_note.dart';
import '../domain/interfaces/quran_notes_interface.dart';
import 'models/quran_note_dto.dart';

class QuranHiveNotesEngine implements QuranNotesDataSource {
  static final QuranHiveNotesEngine instance =
      QuranHiveNotesEngine._privateConstructor();

  Box<List<QuranNoteDto>>? _box;

  QuranHiveNotesEngine._privateConstructor();

  @override
  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(QuranNoteDtoAdapter());
    _box = await Hive.openBox<List<QuranNoteDto>>('notesBox');
  }

  @override
  Future<QuranResponse> create(
    String userId,
    QuranNote note,
  ) async {
    QuranNoteDto noteDto = QuranNoteDto(
      suraIndex: note.suraIndex,
      ayaIndex: note.ayaIndex,
      id: note.id,
      createdOn: note.createdOn,
      note: note.note,
      status: QuranStatusEnum.created.rawString(),
      localId: QuranUtils.uniqueId(),
    );
    String key = "$userId/${note.suraIndex}/${note.ayaIndex}";
    List<QuranNoteDto>? items =
        (_box?.get(key) ?? <QuranNoteDto>[]).cast<QuranNoteDto>();
    items.add(noteDto);
    await _box?.put(
      key,
      items,
    );
    await _box?.flush();

    return QuranResponse(
      isSuccessful: true,
      message: "success",
    );
  }

  @override
  Future<bool> delete(
    String userId,
    QuranNote note,
  ) async {
    String key = "$userId/${note.suraIndex}/${note.ayaIndex}";
    List<QuranNoteDto> items =
        (_box?.get(key) ?? <QuranNoteDto>[]).cast<QuranNoteDto>();
    items.removeWhere((element) =>
        (element.localId == note.localId) ||
        (element.id != null && element.id == note.id));
    _box?.put(
      key,
      items,
    );

    return true;
  }

  @override
  Future<List<QuranNote>> fetch(
    String userId,
    int suraIndex,
    int ayaIndex,
  ) async {
    List<QuranNote> items = [];
    String key = "$userId/$suraIndex/$ayaIndex";
    List<QuranNoteDto> dtoItems =
        (_box?.get(key) ?? <QuranNoteDto>[]).cast<QuranNoteDto>();
    for (QuranNoteDto e in dtoItems) {
      try {
        items.add(QuranNote(
          suraIndex: e.suraIndex,
          ayaIndex: e.ayaIndex,
          id: e.id,
          createdOn: e.createdOn,
          note: e.note,
          status: QuranUtils.statusFromString(e.status),
          localId: e.localId,
        ));
      } catch (_) {}
    }

    return items;
  }

  @override
  Future<bool> update(
    String userId,
    QuranNote note,
  ) async {
    String key = "$userId/${note.suraIndex}/${note.ayaIndex}";
    List<QuranNoteDto> items =
        (_box?.get(key) ?? <QuranNoteDto>[]).cast<QuranNoteDto>();
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
        localId: note.localId,
      );
      items[itemIndex] = updatedDto;
      _box?.put(
        key,
        items,
      );

      return true;
    }

    return false;
  }

  @override
  Future<List<QuranNote>> fetchAll(String userId) async {
    List<QuranNote> items = [];
    final keys = _box?.keys.toList() ?? <dynamic>[];
    for (var key in keys) {
      try {
        List<QuranNoteDto> dtoNotesList =
            (_box?.get(key) ?? <QuranNoteDto>[]).cast<QuranNoteDto>();
        for (QuranNoteDto e in dtoNotesList) {
          items.add(QuranNote(
            suraIndex: e.suraIndex,
            ayaIndex: e.ayaIndex,
            id: e.id,
            createdOn: e.createdOn,
            note: e.note,
            status: QuranUtils.statusFromString(e.status),
            localId: e.localId,
          ));
        }
      } catch (_) {}
    }

    return items;
  }
}
