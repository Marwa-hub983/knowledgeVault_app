import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists whether the user has already completed or skipped onboarding.
class OnboardingService {
  static const String hasSeenOnboardingKey = 'has_seen_onboarding';

  const OnboardingService();

  Future<T> _withPreferences<T>({
    required Future<T> Function(SharedPreferences prefs) action,
    required T fallback,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await action(prefs);
    } on MissingPluginException {
      debugPrint(
        'SharedPreferences plugin is not registered in the current native '
        'build. Stop the app completely and do a full rebuild (flutter run).',
      );
      return fallback;
    }
  }

  Future<bool> hasSeenOnboarding() => _withPreferences<bool>(
        action: (prefs) async => prefs.getBool(hasSeenOnboardingKey) ?? false,
        fallback: false,
      );

  Future<void> markOnboardingCompleted() => _withPreferences<void>(
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
