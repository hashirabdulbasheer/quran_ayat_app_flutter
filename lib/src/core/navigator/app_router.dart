import 'package:ayat_app/src/core/constants/app_constants.dart';
import 'package:ayat_app/src/core/constants/route_constants.dart';
import 'package:ayat_app/src/core/di/service_locator.dart';
import 'package:ayat_app/src/domain/models/surah_index.dart';
import 'package:ayat_app/src/presentation/context/bloc/context_bloc.dart';
import 'package:ayat_app/src/presentation/context/presentation/context_screen.dart';
import 'package:ayat_app/src/presentation/home/bloc/home_bloc.dart';
import 'package:ayat_app/src/presentation/home/home_screen.dart';
import 'package:ayat_app/src/presentation/not_found/not_found_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    debugLogDiagnostics: kDebugMode ? true : false,
    initialLocation: AppRoutes.home.path,
    errorPageBuilder: (context, state) {
      return const NoTransitionPage(child: NotFoundScreen());
    },
    routes: [
      ///
      /// Home
      ///
      GoRoute(
        path: AppRoutes.home.path,
        name: AppRoutes.home.name,
        pageBuilder: (context, state) {
          return NoTransitionPage(
              child: MultiBlocProvider(providers: [
            BlocProvider(create: (context) {
              return getIt<HomeBloc>()
                ..add(HomeInitializeEvent(
                  numberOfAyaPerPage: kNumAyaPerPage,
                ));
            })
          ], child: const HomeScreen()));
        },
      ),
      GoRoute(
        path: AppRoutes.homeSura.path,
        name: AppRoutes.homeSura.name,
        pageBuilder: (context, state) {
          int sura = int.parse(state.pathParameters['sura'] ?? '1');
          if (sura < 1 || sura > 114) {
            sura = 1;
          }

          return NoTransitionPage(
              child: MultiBlocProvider(providers: [
            BlocProvider(create: (context) {
              return getIt<HomeBloc>()
                ..add(HomeInitializeEvent(
                    numberOfAyaPerPage: kNumAyaPerPage,
                    index: SurahIndex.fromHuman(sura: sura, aya: 1)));
            })
          ], child: const HomeScreen()));
        },
      ),
      GoRoute(
        path: AppRoutes.homeSuraAya.path,
        name: AppRoutes.homeSuraAya.name,
        pageBuilder: (context, state) {
          int sura = int.parse(state.pathParameters['sura'] ?? '1');
          int aya = int.parse(state.pathParameters['aya'] ?? '1');
          if (sura < 1 || sura > 114) {
            sura = 1;
            aya = 1;
          }
          return NoTransitionPage(
              child: MultiBlocProvider(providers: [
            BlocProvider(create: (context) {
              return getIt<HomeBloc>()
                ..add(HomeInitializeEvent(
                    numberOfAyaPerPage: kNumAyaPerPage,
                    index: SurahIndex.fromHuman(sura: sura, aya: aya)));
            })
          ], child: const HomeScreen()));
        },
      ),

      ///
      ///  Context Screen
      ///
      GoRoute(
        path: AppRoutes.context.path,
        name: AppRoutes.context.name,
        pageBuilder: (context, state) {
          int sura = int.parse(state.pathParameters['sura'] ?? '1');
          int aya = int.parse(state.pathParameters['aya'] ?? '1');
          return NoTransitionPage(
              child: MultiBlocProvider(providers: [
            BlocProvider(create: (context) {
              return getIt<ContextBloc>()
                ..add(ContextInitializeEvent(
                    index: SurahIndex.fromHuman(sura: sura, aya: aya)));
            })
          ], child: const ContextScreen()));
        },
      ),
      GoRoute(
        path: AppRoutes.contextSura.path,
        name: AppRoutes.contextSura.name,
        pageBuilder: (context, state) {
          int sura = int.parse(state.pathParameters['sura'] ?? '0');
          int aya = 1;
          return NoTransitionPage(
              child: MultiBlocProvider(providers: [
            BlocProvider(create: (context) {
              return getIt<ContextBloc>()
                ..add(ContextInitializeEvent(
                    index: SurahIndex.fromHuman(sura: sura, aya: aya)));
            })
          ], child: const ContextScreen()));
        },
      ),
      GoRoute(
        path: AppRoutes.contextDefault.path,
        name: AppRoutes.contextDefault.name,
        pageBuilder: (context, state) {
          int sura = 1;
          int aya = 1;
          return NoTransitionPage(
              child: MultiBlocProvider(providers: [
            BlocProvider(create: (context) {
              return getIt<ContextBloc>()
                ..add(ContextInitializeEvent(
                    index: SurahIndex.fromHuman(sura: sura, aya: aya)));
            })
          ], child: const ContextScreen()));
        },
      ),
    ],
  );
}
