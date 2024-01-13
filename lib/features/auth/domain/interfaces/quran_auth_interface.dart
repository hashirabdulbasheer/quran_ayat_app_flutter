import '../../../../models/qr_response_model.dart';
import '../../../../models/qr_user_model.dart';
import '../../../core/data/quran_data_interface.dart';

abstract class QuranAuthInterface {
  Future<bool> initialize(QuranDataSource dataSource);

  Future<QuranResponse> login(
    String username,
    String password,
  );

  Future<QuranResponse> signup(
    String name,
    String username,
    String password,
  );

  Future<QuranResponse> update(String name);

  void updateToken();

  Future<QuranResponse> logout();

  Future<QuranResponse> forgotPassword(String email);

  QuranUser? getUser();

  void registerAuthChangeListener(Function listener);

  void unregisterAuthChangeListener(Function listener);
}
