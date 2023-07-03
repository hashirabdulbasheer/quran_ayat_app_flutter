enum BuildFlavor { production, development, staging }

BuildEnvironment get env => _env;
BuildEnvironment _env = BuildEnvironment._init(
  flavor: BuildFlavor.production,
  baseUrl: "",
);

class BuildEnvironment {
  final String baseUrl;
  final BuildFlavor flavor;

  BuildEnvironment._init({
    required this.flavor,
    required this.baseUrl,
  });

  static void init({
    required BuildFlavor flavor,
    required String baseUrl,
  }) {
    BuildEnvironment env = BuildEnvironment._init(
      flavor: flavor,
      baseUrl: baseUrl,
    );
    _env = env;
  }
}
