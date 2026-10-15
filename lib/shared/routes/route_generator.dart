import 'package:go_router/go_router.dart';
import 'package:knowledge_vault_app/features/auth/screens/login_screen.dart';
import 'package:knowledge_vault_app/features/auth/screens/onBoarding_screen.dart';
import 'package:knowledge_vault_app/features/auth/screens/register_screen.dart';
import 'package:knowledge_vault_app/features/documents/screens/library_screen.dart';
import 'package:knowledge_vault_app/features/main/screens/home_screen.dart';
import 'package:knowledge_vault_app/shared/routes/routes.dart';

class RouteGenerator {
  static GoRouter generateRoute() {
    return GoRouter(
      initialLocation: onBoarding,
      routes: [
        GoRoute(
          path: onBoarding,
          builder: (context, state) => OnboardingScreen(),
        ),
        GoRoute(
          path: login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: register,
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: home,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: library,
          builder: (context, state) => const LibraryScreen(),
        ),
      ],
    );
  }
}
