import 'package:knowledge_vault_app/shared/services/preferences_helper.dart';

/// Persists the user's logged-in session flag and basic profile metadata locally.
class AuthSessionService {
  static const String isLoggedInKey = 'is_logged_in';
  static const String userUidKey = 'logged_in_uid';
  static const String userEmailKey = 'logged_in_email';
  static const String userNameKey = 'logged_in_name';
  static const String lastEmailKey = 'last_login_email';

  const AuthSessionService();

  Future<bool> isLoggedIn() => runWithSharedPreferences<bool>(
        action: (prefs) async => prefs.getBool(isLoggedInKey) ?? false,
        fallback: false,
      );

  Future<bool?> storedLoginFlag() => runWithSharedPreferences<bool?>(
        action: (prefs) async => prefs.getBool(isLoggedInKey),
        fallback: null,
      );

  Future<void> saveLoginSession({
    required String uid,
    String? email,
    String? displayName,
  }) =>
      runWithSharedPreferences<void>(
        action: (prefs) async {
          await prefs.setBool(isLoggedInKey, true);
          await prefs.setString(userUidKey, uid);
          if (email != null && email.isNotEmpty) {
            await prefs.setString(userEmailKey, email);
            await prefs.setString(lastEmailKey, email);
          } else {
            await prefs.remove(userEmailKey);
          }
          if (displayName != null && displayName.isNotEmpty) {
            await prefs.setString(userNameKey, displayName);
          } else {
            await prefs.remove(userNameKey);
          }
        },
        fallback: null,
      );

  Future<void> saveUserName(String displayName) =>
      runWithSharedPreferences<void>(
        action: (prefs) async {
          if (displayName.trim().isNotEmpty) {
            await prefs.setString(userNameKey, displayName.trim());
          }
        },
        fallback: null,
      );

  Future<String?> getLastEmail() => runWithSharedPreferences<String?>(
        action: (prefs) async =>
            prefs.getString(lastEmailKey) ?? prefs.getString(userEmailKey),
        fallback: null,
      );

  Future<({String? email, String? displayName})> getStoredUserInfo() =>
      runWithSharedPreferences<({String? email, String? displayName})>(
        action: (prefs) async => (
          email: prefs.getString(userEmailKey) ?? prefs.getString(lastEmailKey),
          displayName: prefs.getString(userNameKey),
        ),
        fallback: (email: null, displayName: null),
      );

  Future<void> clearLoginSession() => runWithSharedPreferences<void>(
        action: (prefs) async {
          await prefs.setBool(isLoggedInKey, false);
          await prefs.remove(userUidKey);
          await prefs.remove(userEmailKey);
          await prefs.remove(userNameKey);
        },
        fallback: null,
      );
}
