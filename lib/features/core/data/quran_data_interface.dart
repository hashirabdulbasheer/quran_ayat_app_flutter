abstract class QuranDataSource {
  Future<void> initialize();

  Future<bool> create(
    String path,
    Map<String, dynamic> item,
  );

  Future<Map<String, dynamic>?> fetch(
    String path,
  );

  Future<dynamic> fetchAll(
    String path,
  );

  Future<bool> delete(
    String path,
  );

  Future<bool> update(
    String path,
    dynamic item,
  );
}
