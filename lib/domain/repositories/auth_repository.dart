abstract class AuthRepository {
  Future<bool> signInWithGoogle();
  Future<bool> signInWithFacebook();
  Future<void> signOut();
  Future<bool> isSignedIn();
}