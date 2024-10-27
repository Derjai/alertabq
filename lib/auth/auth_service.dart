import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          const SnackBar(content: Text('El correo ya está en uso'));
        default:
          const SnackBar(content: Text('Error desconocido'));
      }
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          const SnackBar(content: Text('Usuario no encontrado'));
          break;
        case 'wrong-password':
          const SnackBar(content: Text('Contraseña incorrecta'));
          break;
        default:
          const SnackBar(content: Text('Error desconocido'));
      }
    }
    return null;
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        default:
          const SnackBar(content: Text('Error desconocido'));
      }
    }
  }
}
