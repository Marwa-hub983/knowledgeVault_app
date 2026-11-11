import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:knowledge_vault_app/features/auth/domain/services/onboarding_service.dart';
import 'package:knowledge_vault_app/firebase_options.dart';
import 'my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final showOnboarding =
      await const OnboardingService().shouldShowOnboardingOnLaunch();
  runApp(MyApp(showOnboarding: showOnboarding));
}
