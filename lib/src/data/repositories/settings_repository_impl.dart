import 'package:ayat_app/src/data/local/settings_local_data_source.dart';
import 'package:ayat_app/src/domain/repositories/settings_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl extends SettingsRepository {
  SettingsDataSource dataSource;

  SettingsRepositoryImpl({required this.dataSource});

  @override
  double getFontScale() {
    return dataSource.getFontScale();
  }

  @override
  Future<void> setFontScale(double fontSize) {
    return dataSource.setFontScale(fontSize);
  }
}
