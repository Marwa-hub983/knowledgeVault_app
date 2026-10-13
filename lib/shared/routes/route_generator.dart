import 'package:go_router/go_router.dart';
import 'package:knowledge_vault_app/features/auth/screens/login_screen.dart';
import 'package:knowledge_vault_app/features/auth/screens/onBoarding_screen.dart';
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
        GoRoute(path: login,builder: (context, state) => LoginScreen())
      ],
    );
  }
}
