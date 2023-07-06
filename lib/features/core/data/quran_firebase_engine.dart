import 'package:firebase_database/firebase_database.dart';
import 'package:quran_ayat/utils/logger_utils.dart';

import 'quran_data_interface.dart';

class QuranFirebaseEngine implements QuranDataSource {
  static final QuranFirebaseEngine instance =
      QuranFirebaseEngine._privateConstructor();

  QuranFirebaseEngine._privateConstructor();

  @override
  Future<void> initialize() async {
    return;
  }

  @override
  Future<bool> create(
    String path,
    Map<String, dynamic> item,
  ) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(path);
    DatabaseReference newPostRef = ref.push();
    await newPostRef.set(item);
    try {
      var _ = await ref.set(item);

      return true;
    } catch (error) {
      QuranLogger.logE(
        error,
      );
    }

    return false;
  }

  @override
  Future<Map<String, dynamic>?> fetch(
    String path,
  ) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(path);
    final snapshot = await ref.get();

    return snapshot.value as Map<String, dynamic>?;
  }

  @override
  Future<bool> update(
    String path,
    Map<String, dynamic> item,
  ) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(path);
    try {
      var _ = await ref.set(item);

      return true;
    } catch (error) {
      QuranLogger.logE(
        error,
      );
    }

    return false;
  }

  @override
  Future<bool> delete(
    String path,
  ) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(path);
    await ref.remove();
    try {
      var _ = await ref.remove();

      return true;
    } catch (error) {
      QuranLogger.logE(
        error,
      );
    }

    return false;
  }

  @override
  Future<dynamic> fetchAll(String path) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(path);
    DataSnapshot snapshot = await ref.get();

    return snapshot.value as dynamic;
  }
}
