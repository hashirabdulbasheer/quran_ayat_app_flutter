import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:noble_quran/noble_quran.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BookmarkDataSource {
  NQBookmark? getBookmark();

  void saveBookmark(int sura, int aya);
}

@Injectable(as: BookmarkDataSource)
class BookmarkDataSourceImpl extends BookmarkDataSource {
  final SharedPreferences sharedPreferences;

  BookmarkDataSourceImpl(this.sharedPreferences);

  @override
  NQBookmark? getBookmark() {
    String? bookmarkString = sharedPreferences.getString("bookmark");
    if (bookmarkString == null) {
      return null;
    }

    return NQBookmark.fromJson(jsonDecode(bookmarkString));
  }

  @override
  void saveBookmark(int sura, int aya) {
    final bookmark = NQBookmark(
      surah: sura,
      ayat: aya,
      word: 0,
      seconds: DateTime.now().millisecondsSinceEpoch,
      pixels: 0,
    );
    sharedPreferences.setString("bookmark", json.encode(bookmark.toJson()));
  }
}
