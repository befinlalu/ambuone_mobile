part of 'index.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    await Future.delayed(const Duration(seconds: 1));

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
