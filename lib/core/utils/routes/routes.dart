part of 'index.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // 1. Splash Route
    GoRoute(path: PageRoutes.splash, builder: (context, state) => Splash()),

    GoRoute(path: PageRoutes.welcome, builder: (context, state) => Welcome()),

    GoRoute(path: PageRoutes.home, builder: (context, state) => Home()),
  ],

  redirect: (context, state) async {
    final token = SharedStorages().getAccessToken();
    final path = state.matchedLocation;

    if (path == PageRoutes.splash) {
      // await Future.delayed(const Duration(seconds: 20));
      // return token == null ? PageRoutes.welcome : PageRoutes.home;
      return null;
    }

    final isOnWelcome = path == PageRoutes.welcome;

    // Not logged in → go to welcome
    if (token == null || token.isEmpty) {
      return isOnWelcome ? null : PageRoutes.welcome;
    }

    // Logged in but on welcome → go home
    if (isOnWelcome) {
      return PageRoutes.home;
    }

    return null;
  },
);
