import '../../../../models/qr_response_model.dart';
import '../entities/quran_master_tag.dart';
import '../entities/quran_tag.dart';

abstract class QuranTagsDataSource {
  Future<void> initialize();

  Future<QuranResponse> create(
    String userId,
    QuranTag note,
  );

  Future<QuranResponse> createMaster(
    String userId,
    QuranMasterTag masterTag,
  );

  Future<QuranTag?> fetch(
    String userId,
    int suraIndex,
    int ayaIndex,
  );

  Future<List<QuranMasterTag>> fetchAll(String userId);

  Future<bool> delete(
    String userId,
    QuranTag note,
  );

  Future<bool> update(
    String userId,
    QuranTag note,
  );

  Future<bool> updateMaster(
    String userId,
    QuranMasterTag note,
  );
}
