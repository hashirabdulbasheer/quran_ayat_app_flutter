import '../../../../models/qr_response_model.dart';
import '../entities/quran_master_tag.dart';

abstract class QuranTagsDataSource {
  Future<void> initialize();

  Future<QuranResponse> create(
    String userId,
    QuranMasterTag masterTag,
  );

  Future<List<QuranMasterTag>> fetchAll(String userId);

  Future<bool> update(
    String userId,
    QuranMasterTag note,
  );
}
