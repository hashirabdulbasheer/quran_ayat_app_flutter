import '../../models/qr_response_model.dart';
import '../../models/qr_user_model.dart';

abstract class QuranAuthInterface {
  Future<QuranResponse> login(String username, String password);
  Future<QuranResponse> signup(String name, String username, String password);
  Future<QuranResponse> update(String name);
  Future<QuranResponse> logout();
  Future<QuranUser?> getUser();
}
