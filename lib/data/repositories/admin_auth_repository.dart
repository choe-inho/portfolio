import 'package:firebase_auth/firebase_auth.dart';

/// Wraps Firebase Auth's email/password sign-in and the `admin` custom
/// claim used to gate `/contact-admin` — same mechanism as the legacy app.
class AdminAuthRepository {
  AdminAuthRepository(this._auth);

  final FirebaseAuth _auth;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<bool> isAdmin(User user) async {
    final idTokenResult = await user.getIdTokenResult();
    return idTokenResult.claims?['admin'] == true;
  }

  /// Signs in and verifies the admin claim; signs back out and returns
  /// false if the account is valid but lacks admin rights.
  Future<bool> signInAsAdmin(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) return false;

    final admin = await isAdmin(user);
    if (!admin) {
      await _auth.signOut();
      return false;
    }
    return true;
  }

  Future<void> signOut() => _auth.signOut();
}
