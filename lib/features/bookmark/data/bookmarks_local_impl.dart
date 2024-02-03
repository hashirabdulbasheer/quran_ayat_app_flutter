import 'dart:convert';

import 'package:noble_quran/models/bookmark.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/interfaces/bookmark_interface.dart';

class QuranLocalBookmarksEngine implements QuranBookmarksInterface {
  @override
  Future<bool> save(
    int sura,
    int aya,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmark = NQBookmark(
      surah: sura,
      ayat: aya,
      word: 0,
      seconds: DateTime.now().millisecondsSinceEpoch,
      pixels: 0,
    );
    await prefs.setString(
      "bookmark",
      json.encode(bookmark.toJson()),
    );

    return true;
  }

  @override
  Future<NQBookmark?> fetch() async {
    final prefs = await SharedPreferences.getInstance();
    String? bookmarkString = prefs.getString("bookmark");
    if (bookmarkString != null) {
      final NQBookmark bookmark = NQBookmark.fromJson(
        jsonDecode(bookmarkString) as Map<String, dynamic>,
      );

      return bookmark;
    }

    return null;
  }

  @override
  Future<bool> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("bookmark");

    return Future.value(true);
  }
}
