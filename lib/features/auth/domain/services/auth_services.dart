
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Stream<User?> get authState => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  // Email + password
  Future<UserCredential> signUp(String email, String password) =>
      _auth.createUserWithEmailAndPassword(email: email, password: password);

  Future<UserCredential> signIn(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  Future<void> resetPassword(String email) =>
      _auth.sendPasswordResetEmail(email: email);

  // Google (google_sign_in v7+ API)
  // Future<UserCredential> signInWithGoogle() async {
  //   await GoogleSignIn.instance.initialize(); // call once, ideally at startup
  //   final account = await GoogleSignIn.instance.authenticate();
  //   final idToken = account.authentication.idToken;
  //   final credential = GoogleAuthProvider.credential(idToken: idToken);
  //   return _auth.signInWithCredential(credential);
  // }

  Future<void> signOut() async {
    // await GoogleSignIn.instance.signOut();
    await _auth.signOut();
  }
}