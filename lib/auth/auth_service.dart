import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<AuthResult> loginWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      return AuthResult(success: true, user: userCredential.user);
    } on FirebaseAuthException catch (e) {
      return AuthResult(success: false, error: e.code);
    }
  }

  Future<String?> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
      return null;
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'invalid-email':
          message = 'El correo electrónico no es válido.';
          break;
        case 'user-not-found':
          message = 'No se encontró un usuario con ese correo.';
          break;
        case 'too-many-requests':
          message = 'Demasiadas solicitudes. Inténtalo más tarde.';
          break;
        default:
          message = 'Error desconocido: ${e.message}';
      }
      return message;
    }
  }

  Future<AuthResult> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult(success: true, user: userCredential.user);
    } on FirebaseAuthException catch (e) {
      return AuthResult(success: false, error: e.code);
    }
  }

  Future<AuthResult> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult(success: true, user: userCredential.user);
    } on FirebaseAuthException catch (e) {
      return AuthResult(success: false, error: e.code);
    }
  }

  Future<String?> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'invalid-email':
          message = 'El correo electrónico no es válido.';
          break;
        case 'user-not-found':
          message = 'No se encontró un usuario con ese correo.';
          break;
        case 'too-many-requests':
          message = 'Demasiadas solicitudes. Inténtalo más tarde.';
          break;
        default:
          message = 'Error desconocido: ${e.message}';
      }
      return message;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

class AuthResult {
  final bool success;
  final User? user;
  final String? error;
  AuthResult({required this.success, this.user, this.error});
}
