import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:ayat_app/src/core/di/service_locator.config.dart';
import 'package:shared_preferences/shared_preferences.dart';
final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
configDependencies() => getIt.init();

setupServicesLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
}