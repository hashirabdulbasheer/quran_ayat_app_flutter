class AppRoute {
  const AppRoute({
    required this.name,
    required this.path,
  });

  final String name;
  final String path;
}

class AppRoutes {
  static const AppRoute home = AppRoute(
    name: 'home',
    path: '/',
  );
  static const AppRoute homeSura = AppRoute(
    name: 'homeSura',
    path: '/:sura',
  );
  static const AppRoute homeSuraAya = AppRoute(
    name: 'homeSuraAya',
    path: '/:sura/:aya',
  );

  static const AppRoute context = AppRoute(
    name: 'context',
    path: '/context/:sura/:aya',
  );
  static const AppRoute contextSura = AppRoute(
    name: 'contextSura',
    path: '/context/:sura',
  );
  static const AppRoute contextDefault = AppRoute(
    name: 'contextDefault',
    path: '/context',
  );

  static const AppRoute about = AppRoute(
    name: 'about',
    path: 'about',
  );

  static const AppRoute homeSuraAbout = AppRoute(
    name: 'homeSuraAbout',
    path: 'about',
  );

  static const AppRoute homeSuraAyaAbout = AppRoute(
    name: 'homeSuraAyaAbout',
    path: 'about',
  );
}
