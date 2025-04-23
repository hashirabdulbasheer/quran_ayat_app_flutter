// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../data/local/bookmark_local_data_source.dart' as _i2;
import '../../data/local/quran_local_data_source.dart' as _i722;
import '../../data/local/settings_local_data_source.dart' as _i42;
import '../../data/models/local/data_local_models.dart' as _i70;
import '../../data/repositories/bookmark_repository_impl.dart' as _i51;
import '../../data/repositories/quran_repository_impl.dart' as _i253;
import '../../data/repositories/settings_repository_impl.dart' as _i622;
import '../../domain/models/domain_models.dart' as _i924;
import '../../domain/usecases/fetch_bookmark_usecase.dart' as _i510;
import '../../domain/usecases/fetch_default_translation_usecase.dart' as _i162;
import '../../domain/usecases/fetch_font_scale_usecase.dart' as _i38;
import '../../domain/usecases/fetch_ruku_index_usecase.dart' as _i961;
import '../../domain/usecases/fetch_sura_data_usecase.dart' as _i1048;
import '../../domain/usecases/fetch_sura_titles_usecase.dart' as _i154;
import '../../domain/usecases/fetch_theme_mode_usecase.dart' as _i468;
import '../../domain/usecases/fetch_word_translation_status_usecase.dart'
    as _i869;
import '../../domain/usecases/save_bookmark_usecase.dart' as _i400;
import '../../domain/usecases/save_default_translation_usecase.dart' as _i892;
import '../../domain/usecases/save_theme_mode_usecase.dart' as _i646;
import '../../domain/usecases/save_word_translation_status_usecase.dart'
    as _i990;
import '../../domain/usecases/set_font_scale_usecase.dart' as _i734;
import '../../presentation/context/bloc/context_bloc.dart' as _i537;
import '../../presentation/home/bloc/home_bloc.dart' as _i315;
import '../../presentation/home/home.dart' as _i881;
import '../bloc/app_bloc.dart' as _i406;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i722.QuranDataSource>(() => _i722.QuranLocalDataSourceImpl());
    gh.lazySingleton<_i924.QuranRepository>(() =>
        _i253.QuranRepositoryImpl(dataSource: gh<_i722.QuranDataSource>()));
    gh.factory<_i42.SettingsDataSource>(
        () => _i42.SettingsLocalDataSourceImpl(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i924.SettingsRepository>(() =>
        _i622.SettingsRepositoryImpl(
            dataSource: gh<_i70.SettingsDataSource>()));
    gh.factory<_i2.BookmarkDataSource>(
        () => _i2.BookmarkDataSourceImpl(gh<_i460.SharedPreferences>()));
    gh.factory<_i468.FetchThemeModeUseCase>(
        () => _i468.FetchThemeModeUseCase(gh<_i924.SettingsRepository>()));
    gh.factory<_i734.SetFontScaleUseCase>(
        () => _i734.SetFontScaleUseCase(gh<_i924.SettingsRepository>()));
    gh.factory<_i646.SaveThemeModeUseCase>(
        () => _i646.SaveThemeModeUseCase(gh<_i924.SettingsRepository>()));
    gh.factory<_i38.FetchFontScaleUseCase>(
        () => _i38.FetchFontScaleUseCase(gh<_i924.SettingsRepository>()));
    gh.factory<_i892.SaveDefaultTranslationUseCase>(() =>
        _i892.SaveDefaultTranslationUseCase(gh<_i924.SettingsRepository>()));
    gh.factory<_i162.FetchDefaultTranslationUseCase>(() =>
        _i162.FetchDefaultTranslationUseCase(gh<_i924.SettingsRepository>()));
    gh.factory<_i990.SaveWordTranslationStatusUseCase>(() =>
        _i990.SaveWordTranslationStatusUseCase(gh<_i924.SettingsRepository>()));
    gh.factory<_i869.FetchWordTranslationStatusUseCase>(() =>
        _i869.FetchWordTranslationStatusUseCase(
            gh<_i924.SettingsRepository>()));
    gh.lazySingleton<_i406.AppBloc>(() => _i406.AppBloc(
          fetchThemeModeUseCase: gh<_i468.FetchThemeModeUseCase>(),
          saveThemeModeUseCase: gh<_i646.SaveThemeModeUseCase>(),
        ));
    gh.factory<_i154.FetchSuraTitlesUseCase>(
        () => _i154.FetchSuraTitlesUseCase(gh<_i924.QuranRepository>()));
    gh.factory<_i1048.FetchSuraUseCase>(
        () => _i1048.FetchSuraUseCase(gh<_i924.QuranRepository>()));
    gh.factory<_i961.FetchRukuIndexUseCase>(
        () => _i961.FetchRukuIndexUseCase(gh<_i924.QuranRepository>()));
    gh.lazySingleton<_i924.BookmarkRepository>(() =>
        _i51.BookmarkRepositoryImpl(dataSource: gh<_i70.BookmarkDataSource>()));
    gh.factory<_i537.ContextBloc>(() => _i537.ContextBloc(
          fetchSuraUseCase: gh<_i1048.FetchSuraUseCase>(),
          fetchSuraTitlesUseCase: gh<_i154.FetchSuraTitlesUseCase>(),
          fetchFontScaleUseCase: gh<_i38.FetchFontScaleUseCase>(),
        ));
    gh.factory<_i400.SaveBookmarkUseCase>(
        () => _i400.SaveBookmarkUseCase(gh<_i924.BookmarkRepository>()));
    gh.factory<_i510.FetchBookmarkUseCase>(
        () => _i510.FetchBookmarkUseCase(gh<_i924.BookmarkRepository>()));
    gh.factory<_i315.HomeBloc>(() => _i315.HomeBloc(
          fetchSuraTitlesUseCase: gh<_i881.FetchSuraTitlesUseCase>(),
          fetchFontScaleUseCase: gh<_i881.FetchFontScaleUseCase>(),
          setFontScaleUseCase: gh<_i881.SetFontScaleUseCase>(),
          fetchSuraUseCase: gh<_i881.FetchSuraUseCase>(),
          fetchRukuIndexUseCase: gh<_i881.FetchRukuIndexUseCase>(),
          fetchBookmarkUseCase: gh<_i881.FetchBookmarkUseCase>(),
          saveBookmarkUseCase: gh<_i881.SaveBookmarkUseCase>(),
          fetchDefaultTranslationUseCase:
              gh<_i162.FetchDefaultTranslationUseCase>(),
          saveDefaultTranslationUseCase:
              gh<_i892.SaveDefaultTranslationUseCase>(),
          fetchWordTranslationStatusUseCase:
              gh<_i869.FetchWordTranslationStatusUseCase>(),
          saveWordTranslationStatusUseCase:
              gh<_i990.SaveWordTranslationStatusUseCase>(),
        ));
    return this;
  }
}
