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
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final session = SharedStorages().getAccessToken();

    if (session != null) {
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "No matter whether you are in an emergency",
                  textAlign: TextAlign.center,
                  style: AppFontStyles.h6Hint(context),
                ),
                Text(
                  "We are here to help you",
                  textAlign: TextAlign.center,
                  style: AppFontStyles.h6Hint(context),
                ),
                SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
