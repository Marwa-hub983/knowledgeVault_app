import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:knowledge_vault_app/features/auth/domain/services/auth_session_service.dart';

class AuthService {
  final FirebaseAuth? _injectedAuth;
  final AuthSessionService sessionService;

  const AuthService({
    FirebaseAuth? auth,
    this.sessionService = const AuthSessionService(),
  }) : _injectedAuth = auth;

  FirebaseAuth? get _auth {
    if (_injectedAuth != null) return _injectedAuth;
    if (Firebase.apps.isEmpty) return null;
    return FirebaseAuth.instance;
  }

  Stream<User?> get authState {
    final auth = _auth;
    if (auth == null) return const Stream.empty();
    return auth.authStateChanges();
  }

  User? get currentUser => _auth?.currentUser;

  Future<User?> _resolveFirebaseUser() async {
    final auth = _auth;
    if (auth == null) return null;
    final current = auth.currentUser;
    if (current != null) return current;
    try {
      return await auth
          .authStateChanges()
          .firstWhere((user) => user != null)
          .timeout(
            const Duration(milliseconds: 1500),
            onTimeout: () => auth.currentUser,
          );
    } catch (_) {
      return auth.currentUser;
    }
  }

  Future<void> _signOutFirebase() async {
    final auth = _auth;
    if (auth != null) {
      await auth.signOut();
    }
  }

  /// Resolves whether a user session should auto-login on app launch.
  Future<bool> resolveLoginOnLaunch({required bool showOnboarding}) async {
    // On first-time onboarding screen, do not auto-login to home.
    if (showOnboarding) {
      return false;
    }

    final storedFlag = await sessionService.storedLoginFlag();
    final firebaseUser = await _resolveFirebaseUser();

    // If user explicitly logged out, keep them logged out until they log in again.
    if (storedFlag == false) {
      return false;
    }

    // If Firebase Auth has an active signed-in user, persist & keep logged in.
    if (firebaseUser != null) {
      String? name = firebaseUser.displayName;
      if (name == null || name.trim().isEmpty) {
        final stored = await sessionService.getStoredUserInfo();
        name = stored.displayName;
      }
      await sessionService.saveLoginSession(
        uid: firebaseUser.uid,
        email: firebaseUser.email,
        displayName: name,
      );
      return true;
    }

    // Keep the user logged in when session was stored locally until explicit logout.
    return storedFlag == true;
  }

  // Email + password sign up
  Future<UserCredential> signUp(
    String email,
    String password, {
    String? fullName,
  }) async {
    final auth = _auth;
    if (auth == null) {
      throw FirebaseException(
        plugin: 'firebase_auth',
        code: 'no-app',
        message: 'Firebase has not been initialized',
      );
    }
    final credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user != null && fullName != null && fullName.trim().isNotEmpty) {
      try {
        await user.updateDisplayName(fullName.trim());
        await user.reload();
      } catch (_) {}
    }

    final effectiveUser = auth.currentUser ?? user;
    final effectiveName = fullName?.trim() ?? effectiveUser?.displayName;

    if (effectiveUser != null) {
      await sessionService.saveLoginSession(
        uid: effectiveUser.uid,
        email: effectiveUser.email ?? email,
        displayName: effectiveName,
      );
    }
    return credential;
  }

  // Email + password sign in
  Future<UserCredential> signIn(String email, String password) async {
    final auth = _auth;
    if (auth == null) {
      throw FirebaseException(
        plugin: 'firebase_auth',
        code: 'no-app',
        message: 'Firebase has not been initialized',
      );
    }
    final credential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user != null) {
      String? name = user.displayName;
      if (name == null || name.trim().isEmpty) {
        final stored = await sessionService.getStoredUserInfo();
        name = stored.displayName;
      }
      if (name == null || name.trim().isEmpty) {
        name = email.split('@').first;
      }
      await sessionService.saveLoginSession(
        uid: user.uid,
        email: user.email ?? email,
        displayName: name,
      );
    }
    return credential;
  }

  Future<void> resetPassword(String email) async {
    final auth = _auth;
    if (auth == null) {
      throw FirebaseException(
        plugin: 'firebase_auth',
        code: 'no-app',
        message: 'Firebase has not been initialized',
      );
    }
    await auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await _signOutFirebase();
    await sessionService.clearLoginSession();
  }
}
