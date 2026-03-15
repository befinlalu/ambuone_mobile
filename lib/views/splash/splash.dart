part of 'index.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final _repo = VersionRepoImpli();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await Future.wait([
      Future.delayed(const Duration(seconds: 2)),
      _checkConfig(),
    ]);
  }

  Future<void> _checkConfig() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final installedVersion = info.version;

      final response = await _repo.getVersion();
      final version = response.data;

      if (!mounted) return;

      if (version == null) {
        // Config call returned no data — proceed normally
        _navigateNext();
        return;
      }

      if (version.appMaintenance) {
        context.go(PageRoutes.maintain);
        return;
      }

      if (version.requiresUpdate(installedVersion)) {
        context.go(PageRoutes.update);
        return;
      }

      _navigateNext();
    } catch (_) {
      if (mounted) _navigateNext();
    }
  }

  void _navigateNext() {
    if (!mounted) return;
    final session = SharedStorages().getAccessToken();
    if (session == null || session.isEmpty) {
      context.go(PageRoutes.welcome);
    } else {
      context.go(PageRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Image.asset(AppImages.appLogo),
          ),
        ],
      ),
    );
  }
}
