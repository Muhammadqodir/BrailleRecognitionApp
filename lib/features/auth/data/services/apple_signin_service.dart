import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../../core/error/exceptions.dart';

class AppleSignInService {
  Future<AuthorizationCredentialAppleID?> signIn() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      return credential;
    } catch (e) {
      throw AuthException('Apple sign-in failed: ${e.toString()}');
    }
  }
}
