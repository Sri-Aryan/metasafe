import 'package:go_router/go_router.dart';
import 'features/home_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/splash/splash_screen.dart';
import 'features/sucess_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => OnboardingScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/success',
      builder: (context, state) {
        final data = state.extra as Map<String, String>;
        return SuccessScreen(
          cleanedImagePath: data['cleanedImagePath']!,
          originalFileName: data['originalFileName']!,
        );
      },
    ),
  ],
  redirect: (context, state) {
    // Redirect to onboarding if not completed
    return null;
  },
);
