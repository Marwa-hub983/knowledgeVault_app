import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:knowledge_vault_app/features/auth/domain/services/auth_services.dart';
import 'package:knowledge_vault_app/features/auth/domain/services/auth_session_service.dart';
import 'package:knowledge_vault_app/features/auth/domain/services/onboarding_service.dart';
import 'package:knowledge_vault_app/firebase_options.dart';
import 'my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  const sessionService = AuthSessionService();
  const authService = AuthService(sessionService: sessionService);
  const onboardingService = OnboardingService();

  final hasSeenOnboarding = await onboardingService.hasSeenOnboarding();
  final alreadyHasSession = authService.currentUser != null || (await sessionService.isLoggedIn());

  final isLoggedIn = await authService.resolveLoginOnLaunch(
    showOnboarding: !hasSeenOnboarding && !alreadyHasSession,
  );

  // If user is logged in, onboarding must never be shown
  final showOnboarding = isLoggedIn ? false : !hasSeenOnboarding;
  if (showOnboarding) {
    await onboardingService.markOnboardingCompleted();
  }

  runApp(
    MyApp(
      showOnboarding: showOnboarding,
      isLoggedIn: isLoggedIn,
    ),
  );
}
