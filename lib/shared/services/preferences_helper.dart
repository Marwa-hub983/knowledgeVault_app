import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Runs a [SharedPreferences] operation and falls back cleanly if the native
/// plugin channel is unavailable (e.g., before a full rebuild).
Future<T> runWithSharedPreferences<T>({
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

