part of 'index.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // 1. Splash Route
    GoRoute(
      path: PageRoutes.splash,
      builder: (context, state) =>
          BlocProvider(create: (context) => sl<AuthBloc>(), child: Splash()),
    ),

    GoRoute(path: PageRoutes.welcome, builder: (context, state) => Welcome()),

    GoRoute(
      path: PageRoutes.home,
      builder: (context, state) =>
          BlocProvider(create: (context) => sl<HomeBloc>(), child: Home()),
    ),

    GoRoute(
      path: PageRoutes.login,
      builder: (context, state) =>
          BlocProvider(create: (context) => sl<AuthBloc>(), child: Login()),
    ),

    GoRoute(
      path: PageRoutes.register,
      builder: (context, state) =>
          BlocProvider(create: (context) => sl<AuthBloc>(), child: Register()),
    ),

    GoRoute(
      path: '/lock-sos',
      builder: (context, state) => BlocProvider(
        create: (context) => sl<HomeBloc>(),
        child: const SosPage(),
      ),
    ),
  ],
  redirect: (context, state) async {
    final token = SharedStorages().getAccessToken();
    final path = state.matchedLocation;

    // 1. Always allow Splash
    if (path == PageRoutes.splash) return null;

    // 2. Define Public Pages (Pages you can visit without logging in)
    final publicPages = [
      PageRoutes.welcome,
      PageRoutes.login,
      PageRoutes.register,
    ];
    final isGoingToPublicPage = publicPages.contains(path);

    // 3. Scenario: User is NOT logged in
    if (token == null || token.isEmpty) {
      // If they are trying to go to a public page, let them pass.
      // If they try to go to Home/Profile, force them to Welcome.
      return isGoingToPublicPage ? null : PageRoutes.welcome;
    }

    // 4. Scenario: User IS logged in
    // If they try to access login/register/welcome while logged in,
    // redirect them to Home.
    if (isGoingToPublicPage) {
      return PageRoutes.home;
    }

    return null; // Allow navigation to protected pages (Home, etc.)
  },
);
