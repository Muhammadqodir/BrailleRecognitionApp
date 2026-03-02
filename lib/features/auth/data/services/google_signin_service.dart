import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/error/exceptions.dart';

class GoogleSignInService {
  final GoogleSignIn _googleSignIn;

  GoogleSignInService(this._googleSignIn);

  Future<String?> signIn() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        return null; // User cancelled
      }

      final authentication = await account.authentication;
      return authentication.idToken;
    } catch (e) {
      throw AuthException('Google sign-in failed: ${e.toString()}');
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      throw AuthException('Google sign-out failed: ${e.toString()}');
    }
  }
}
