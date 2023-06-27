import '../../../../models/qr_response_model.dart';
import '../entities/quran_tag.dart';

abstract class QuranTagsDataSource {
  Future<void> initialize();

  Future<QuranResponse> create(
    String userId,
    QuranTag masterTag,
  );

  Future<List<QuranTag>> fetchAll(String userId);

  Future<bool> update(
    String userId,
    QuranTag note,
  );
}
