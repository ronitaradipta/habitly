import 'package:firebase_auth/firebase_auth.dart';

/// Maps FirebaseAuthException to user-friendly error messages.
class AuthErrorMapper {
  static String mapException(FirebaseAuthException e) {
    switch (e.code) {
      // Login errors
      case 'user-not-found':
        return 'No account found with this email. Please register first.';
      case 'wrong-password':
        return 'The password you entered is incorrect. Please try again.';
      case 'invalid-credential':
        return 'Invalid email or password. Please try again.';
      case 'user-disabled':
        return 'Your account has been disabled. Contact support for assistance.';
      case 'too-many-requests':
        return 'Too many login attempts. Please try again later.';

      // Register errors
      case 'email-already-in-use':
        return 'This email is already registered. Please login.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'invalid-email':
        return 'Invalid email format.';
      case 'operation-not-allowed':
        return 'Email/password registration is not enabled.';

      // Network errors
      case 'network-request-failed':
        return 'No internet connection. Check your network and try again.';

      default:
        return 'An error occurred. Please try again. (${e.code})';
    }
  }
}
