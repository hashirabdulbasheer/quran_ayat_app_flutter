import '../../../../models/qr_response_model.dart';
import '../entities/quran_master_tag.dart';

abstract class QuranTagsDataSource {
  Future<void> initialize();

  Future<QuranResponse> createMaster(
    String userId,
    QuranMasterTag masterTag,
  );

  Future<List<QuranMasterTag>> fetchAll(String userId);

  Future<bool> updateMaster(
    String userId,
    QuranMasterTag note,
  );
}
