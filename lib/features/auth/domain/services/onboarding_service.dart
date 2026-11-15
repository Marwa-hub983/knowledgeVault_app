import 'package:knowledge_vault_app/shared/services/preferences_helper.dart';

/// Persists whether the user has already completed or skipped onboarding.
class OnboardingService {
  static const String hasSeenOnboardingKey = 'has_seen_onboarding';

  const OnboardingService();

  Future<bool> hasSeenOnboarding() => runWithSharedPreferences<bool>(
        action: (prefs) async => prefs.getBool(hasSeenOnboardingKey) ?? false,
        fallback: false,
      );

  Future<void> markOnboardingCompleted() => runWithSharedPreferences<void>(
        action: (prefs) => prefs.setBool(hasSeenOnboardingKey, true),
        fallback: null,
      );

  /// Returns true only on the very first launch, and immediately records that
  /// onboarding has been shown so restarting the app skips it next time.
  Future<bool> shouldShowOnboardingOnLaunch() async {
    final hasSeen = await hasSeenOnboarding();
    if (!hasSeen) {
      await markOnboardingCompleted();
      return true;
    }
    return false;
  }
}
