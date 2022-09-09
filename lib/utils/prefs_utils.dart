import 'dart:convert';
import 'package:noble_quran/models/bookmark.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuranPreferences {
  static void saveBookmark(
    int surahIndex,
    int ayaIndex,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmark = NQBookmark(
      surah: surahIndex,
      ayat: ayaIndex,
      word: 0,
      seconds: 0,
      pixels: 0,
    );
    await prefs.setString(
      "bookmark",
      json.encode(bookmark.toJson()),
    );
  }

  static void clearBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("bookmark");
  }

  static Future<NQBookmark?> getBookmark() async {
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
}
